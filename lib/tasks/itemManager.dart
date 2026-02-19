import 'package:flutter/material.dart';
// model + manager
class Item {
  final int id;
  String name;
  int quantity;
  bool isCompleted;

  Item({
    required this.id,
    required this.name,
    required this.quantity,
    this.isCompleted = false,
  });

  void toggleCompleted() => isCompleted = !isCompleted;

  @override
  String toString() =>
      'Item(id:$id, name:"$name", qty:$quantity, completed:$isCompleted)';
}

class ItemManager {
  final List<Item> _items = [];
  int _nextId = 1;

  List<Item> get items => List.unmodifiable(_items);

  Item addItem(String name, int quantity) {
    final item = Item(id: _nextId++, name: name, quantity: quantity);
    _items.add(item);
    _log("ADD", item);
    _logAll();
    return item;
  }

  bool updateItem(int id, String name, int quantity) {
    final index = _items.indexWhere((e) => e.id == id);
    if (index == -1) {
      print("❌ UPDATE FAILED: Item not found");
      return false;
    }

    _items[index].name = name;
    _items[index].quantity = quantity;

    _log("UPDATE", _items[index]);
    _logAll();
    return true;
  }

  bool removeItem(int id) {
    final index = _items.indexWhere((e) => e.id == id);
    if (index == -1) {
      print("❌ DELETE FAILED: Item not found");
      return false;
    }

    final removed = _items.removeAt(index);
    _log("DELETE", removed);
    _logAll();
    return true;
  }

  bool toggleCompleted(int id) {
    final index = _items.indexWhere((e) => e.id == id);
    if (index == -1) {
      print("❌ TOGGLE FAILED: Item not found");
      return false;
    }

    _items[index].toggleCompleted();
    _log("TOGGLE", _items[index]);
    _logAll();
    return true;
  }

  List<Item> search(String query) {
    final result = _items
        .where((e) => e.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    print("🔍 SEARCH: \"$query\" -> ${result.length} result(s)");
    return result;
  }

  void clearAll() {
    _items.clear();
    _nextId = 1;
    print("🧹 ALL ITEMS CLEARED");
  }

  void _log(String action, Item item) {
    print("✅ $action -> $item");
  }

  void _logAll() {
    print("📦 CURRENT LIST (${_items.length})");
    for (var e in _items) {
      print("   • $e");
    }
    print("----------------------------------");
  }
}

/// ==========================
/// UI SCREEN (BLACK THEME)
/// ==========================
class ItemManagerScreen extends StatefulWidget {
  const ItemManagerScreen({super.key});

  @override
  State<ItemManagerScreen> createState() => _ItemManagerScreenState();
}

class _ItemManagerScreenState extends State<ItemManagerScreen> {
  final ItemManager manager = ItemManager();

  final nameController = TextEditingController();
  final qtyController = TextEditingController();
  final searchController = TextEditingController();

  List<Item> visibleItems = [];

  @override
  void initState() {
    super.initState();
    visibleItems = manager.items;
  }

  @override
  void dispose() {
    nameController.dispose();
    qtyController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _refresh() {
    setState(() => visibleItems = manager.items);
  }

  void _addItem() {
    final name = nameController.text.trim();
    final qty = int.tryParse(qtyController.text.trim());

    if (name.isEmpty || qty == null || qty <= 0) return;

    manager.addItem(name, qty);
    nameController.clear();
    qtyController.clear();
    _refresh();
  }

  void _applySearch(String query) {
    setState(() {
      visibleItems =
          query.isEmpty ? manager.items : manager.search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Item Manager (OOP)",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.white),
            onPressed: () {
              manager.clearAll();
              _refresh();
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Add Section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _darkField(nameController, "Item Name"),
                const SizedBox(height: 10),
                _darkField(qtyController, "Quantity",
                    isNumber: true),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: _addItem,
                  child: const Text("Add Item"),
                ),
              ],
            ),
          ),

          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _darkField(searchController, "Search",
                onChanged: _applySearch),
          ),

          const SizedBox(height: 10),

          // List
          Expanded(
            child: visibleItems.isEmpty
                ? const Center(
                    child: Text(
                      "No Items Found",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: visibleItems.length,
                    itemBuilder: (context, index) {
                      final item = visibleItems[index];
                      return Card(
                        color: Colors.grey[900],
                        child: ListTile(
                          title: Text(
                            item.name,
                            style: TextStyle(
                              color: Colors.white,
                              decoration: item.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Text(
                            "Qty: ${item.quantity}",
                            style: const TextStyle(
                                color: Colors.grey),
                          ),
                          trailing: Wrap(
                            children: [
                              IconButton(
                                icon: Icon(
                                  item.isCompleted
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  manager.toggleCompleted(
                                      item.id);
                                  _refresh();
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () {
                                  manager.removeItem(item.id);
                                  _refresh();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }

  Widget _darkField(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType:
          isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
