Inventory.destroy_all
Stock.destroy_all
StockInventoryItem.destroy_all

inventories = [
  { code: "INV001", name: "Suya", description: "Spiced grilled meat", expires: true, state: "piece" },
  { code: "INV002", name: "Suya Pepper", description: "Spicy suya seasoning", expires: false, state: "solid" },
  { code: "INV003", name: "Cheese", description: "Processed dairy cheese", expires: true, state: "solid" },
  { code: "INV004", name: "Chicken", description: "Raw or cooked chicken meat", expires: true, state: "solid" },
  { code: "INV005", name: "Beef", description: "Raw or grilled beef", expires: true, state: "solid" },
  { code: "INV006", name: "Fat", description: "Animal or cooking fat", expires: true, state: "solid" },
  { code: "INV007", name: "Vanilla Flavour", description: "Vanilla flavoring agent", expires: false, state: "liquid" },
  { code: "INV008", name: "Cream", description: "Dairy cream", expires: true, state: "liquid" },
  { code: "INV009", name: "Vinegar", description: "Food-grade vinegar", expires: false, state: "liquid" },
  { code: "INV010", name: "Salt", description: "Table salt", expires: false, state: "solid" },
  { code: "INV011", name: "Honey", description: "Natural honey", expires: false, state: "liquid" },
  { code: "INV012", name: "Black Pepper", description: "Ground black pepper", expires: false, state: "solid" },
  { code: "INV013", name: "White Pepper", description: "Ground white pepper", expires: false, state: "solid" },
  { code: "INV014", name: "Paprika", description: "Ground paprika spice", expires: false, state: "solid" },
  { code: "INV015", name: "Chicken Seasoning", description: "Seasoning for chicken", expires: false, state: "piece" },
  { code: "INV016", name: "Meat Tenderizer", description: "Meat softening powder", expires: false, state: "solid" },
  { code: "INV017", name: "Egg", description: "Raw egg", expires: true, state: "piece" },
  { code: "INV018", name: "Sugar", description: "Granulated sugar", expires: false, state: "solid" },
  { code: "INV019", name: "Chilli Pepper", description: "Ground or fresh chili pepper", expires: false, state: "solid" },
  { code: "INV020", name: "Cornflakes", description: "Crispy corn cereal", expires: true, state: "solid" },
  { code: "INV021", name: "Flour", description: "Wheat flour", expires: true, state: "solid" },
  { code: "INV022", name: "Improver", description: "Baking improver", expires: true, state: "solid" },
  { code: "INV023", name: "Yeast", description: "Baking yeast", expires: true, state: "solid" },
  { code: "INV024", name: "Milk", description: "Dairy or powdered milk", expires: true, state: "liquid" },
  { code: "INV025", name: "Mustard", description: "Mustard condiment", expires: true, state: "liquid" },
  { code: "INV026", name: "Oreos", description: "Oreo cookies", expires: true, state: "solid" },
  { code: "INV027", name: "Milo", description: "Chocolate malt drink powder", expires: true, state: "solid" },
  { code: "INV028", name: "Lettuce", description: "Fresh lettuce", expires: true, state: "solid" },
  { code: "INV029", name: "Tomato", description: "Fresh tomato", expires: true, state: "solid" },
  { code: "INV030", name: "Cucumber", description: "Fresh cucumber", expires: true, state: "solid" },
  { code: "INV031", name: "Onions", description: "Fresh onions", expires: true, state: "solid" },
  { code: "INV032", name: "Raw Fries", description: "Uncooked fries", expires: true, state: "solid" },
  { code: "INV033", name: "Vegetable Oil", description: "Cooking oil", expires: true, state: "liquid" },
  { code: "INV034", name: "Sausage", description: "Processed sausage", expires: true, state: "solid" },
  { code: "INV035", name: "Bbq Sauce 560G", description: "BBQ sauce bottle", expires: true, state: "liquid" },
  { code: "INV036", name: "Rosemary", description: "Dried rosemary herb", expires: false, state: "solid" },
  { code: "INV037", name: "Ginger", description: "Fresh or ground ginger", expires: true, state: "solid" },
  { code: "INV038", name: "Garlic", description: "Fresh or powdered garlic", expires: true, state: "solid" },
  { code: "INV039", name: "Soy Sauce", description: "Soy sauce condiment", expires: true, state: "liquid" },
  { code: "INV040", name: "Ketchup", description: "Tomato ketchup", expires: true, state: "liquid" },
  { code: "INV041", name: "Skewer", description: "Wooden or metal skewers", expires: false, state: "solid" },
  { code: "INV042", name: "Water", description: "Drinking water", expires: true, state: "liquid" },
  { code: "INV043", name: "Burger Box", description: "Packaging for burgers", expires: false, state: "solid" },
  { code: "INV044", name: "Suya Burger Box", description: "Packaging for suya burgers", expires: false, state: "solid" },
  { code: "INV045", name: "Jbaby Box", description: "Jbaby product box", expires: false, state: "solid" },
  { code: "INV046", name: "Fries Pack", description: "Packaging for fries", expires: false, state: "solid" },
  { code: "INV047", name: "Jbaby Straw", description: "Drinking straw", expires: false, state: "solid" },
  { code: "INV048", name: "Burger Nylon", description: "Nylon wrap for burgers", expires: false, state: "solid" },
  { code: "INV049", name: "Brown Paper", description: "Wrapping brown paper", expires: false, state: "solid" },
  { code: "INV050", name: "White Paper", description: "Wrapping white paper", expires: false, state: "solid" },
  { code: "INV051", name: "Serviette", description: "Disposable serviette", expires: false, state: "solid" },
  { code: "INV052", name: "Jbaby Stickers", description: "Branded stickers", expires: false, state: "solid" },
  { code: "INV053", name: "Vanilla Biscuit", description: "Flavored biscuit", expires: true, state: "solid" },
  { code: "INV054", name: "Butter", description: "Dairy butter", expires: true, state: "solid" },
  { code: "INV055", name: "Bread Crumbs", description: "Crushed dry bread", expires: true, state: "solid" },
  { code: "INV056", name: "Jbaby Container", description: "Reusable container", expires: false, state: "solid" },
  { code: "INV057", name: "Coke", description: "Coca-Cola soft drink", expires: true, state: "liquid" },
  { code: "INV058", name: "Fanta", description: "Fanta soft drink", expires: true, state: "liquid" },
  { code: "INV059", name: "Sprite", description: "Sprite soft drink", expires: true, state: "liquid" },
  { code: "INV060", name: "Pepsi", description: "Pepsi soft drink", expires: true, state: "liquid" },
  { code: "INV061", name: "Ketchup Cup", description: "Cup for ketchup", expires: false, state: "solid" },
  { code: "INV062", name: "Ice Cream", description: "Frozen dairy dessert", expires: true, state: "solid" }
]

inventories.each do |inventory|
  Inventory.create(inventory)
end

stocks = [
  {
    code: "STK001",
    name: "Burger bread/buns",
    description: "3kg (25 Buns) of delicious burger bread/buns",
    state: "pieces",
    stock_inventory_items: [
      { code: "INV021", quantity: 3000 },
      { code: "INV018", quantity: 450 },
      { code: "INV022", quantity: 15 },
      { code: "INV054", quantity: 450 },
      { code: "INV024", quantity: 150 },
      { code: "INV023", quantity: 60 },
      { code: "INV010", quantity: 30 },
      { code: "INV017", quantity: 3 }
    ]
  },
  {
    code: "STK002",
    name: "Mayonnaise",
    description: "1.2 litres of delicious mayonnaise",
    state: "liquid",
    stock_inventory_items: [
      { code: "INV017", quantity: 4 },
      { code: "INV033", quantity: 1200 },
      { code: "INV025", quantity: 15 },
      { code: "INV009", quantity: 15 },
      { code: "INV018", quantity: 15 },
      { code: "INV010", quantity: 0.6 }
    ]
  },
  {
    code: "STK003",
    name: "Chicken Sauce",
    description: "1.2l of delicious chicken sauce",
    state: "liquid",
    stock_inventory_items: [
      { code: "INV017", quantity: 4 },
      { code: "INV033", quantity: 1200 },
      { code: "INV025", quantity: 30 },
      { code: "INV009", quantity: 15 },
      { code: "INV018", quantity: 15 },
      { code: "INV010", quantity: 0.6 },
      { code: "INV040", quantity: 125 },
      { code: "INV011", quantity: 125 },
      { code: "INV035", quantity: 15 }
    ]
  },
  {
    code: "STK004",
    name: "Beef Sauce",
    description: "1.2l of delicious beef sauce",
    state: "liquid",
    stock_inventory_items: [
      { code: "INV017", quantity: 4 },
      { code: "INV033", quantity: 1200 },
      { code: "INV025", quantity: 15 },
      { code: "INV009", quantity: 30 },
      { code: "INV018", quantity: 30 },
      { code: "INV010", quantity: 0.6 },
      { code: "INV040", quantity: 125 },
      { code: "INV012", quantity: "F" },
      { code: "INV014", quantity: 15 },
      { code: "INV013", quantity: 15 }
    ]
  },
  {
    code: "STK005",
    name: "Chicken Patties",
    description: "A pack of 50 delicious chicken patties, perfect for any occasion",
    state: "pieces",
    stock_inventory_items: [
      { code: "INV004", quantity: 10_000 },
      { code: "INV017", quantity: 10 },
      { code: "INV015", quantity: 7.5 },
      { code: "INV055", quantity: 700 },
      { code: "INV014", quantity: 7.5 },
      { code: "INV036", quantity: 7.5 },
      { code: "INV012", quantity: 7.5 },
      { code: "INV013", quantity: 7.5 },
      { code: "INV019", quantity: 7.5 },
      { code: "INV039", quantity: 62 },
      { code: "INV031", quantity: 1000 },
      { code: "INV037", quantity: 100 },
      { code: "INV038", quantity: 100 },
      { code: "INV010", quantity: 11.25 }
    ]
  },
  {
    code: "STK006",
    name: "Beef Patties",
    description: "A pack of 50 delicious beef patties, perfect for any occasion",
    state: "pieces",
    stock_inventory_items: [
      { code: "INV005", quantity: 10_000 },
      { code: "INV006", quantity: 2000 },
      { code: "INV016", quantity: 7.5 },
      { code: "INV017", quantity: 10 },
      { code: "INV055", quantity: 70 },
      { code: "INV014", quantity: 7.5 },
      { code: "INV036", quantity: 7.5 },
      { code: "INV012", quantity: 7.5 },
      { code: "INV013", quantity: 7.5 },
      { code: "INV019", quantity: 7.5 },
      { code: "INV039", quantity: 62 },
      { code: "INV031", quantity: 1000 },
      { code: "INV037", quantity: 100 },
      { code: "INV038", quantity: 100 },
      { code: "INV010", quantity: 11.25 }
    ]
  },
  {
    code: "STK007",
    name: "Suya Patties",
    description: "200g of premium Suya patties, perfect for grilling",
    state: "pieces",
    stock_inventory_items: [
      { code: "INV005", quantity: 10_000 },
      { code: "INV006", quantity: 2000 },
      { code: "INV016", quantity: 7.5 },
      { code: "INV017", quantity: 10 },
      { code: "INV055", quantity: 70 },
      { code: "INV014", quantity: 7.5 },
      { code: "INV036", quantity: 7.5 },
      { code: "INV012", quantity: 7.5 },
      { code: "INV013", quantity: 7.5 },
      { code: "INV019", quantity: 7.5 },
      { code: "INV039", quantity: 62 },
      { code: "INV031", quantity: 1000 },
      { code: "INV037", quantity: 100 },
      { code: "INV038", quantity: 100 },
      { code: "INV010", quantity: 11.25 },
      { code: "INV001", quantity: 1 },
      { code: "INV002", quantity: 5 }
    ]
  },
  {
    code: "STK008",
    name: "Crunchy Dip",
    description: "Contains 2 litres of crunchy dip",
    state: "liquid",
    stock_inventory_items: [
      { code: "INV021", quantity: 1000 },
      { code: "INV012", quantity: 1.8 },
      { code: "INV036", quantity: 1.8 },
      { code: "INV010", quantity: 1.8 },
      { code: "INV042", quantity: 750 },
      { code: "INV015", quantity: 1.8 },
      { code: "INV014", quantity: 1.8 },
      { code: "INV019", quantity: 1.8 }
    ]
  }
]

stocks.each do |item|
  stock = Stock.create({ code: item[:code], name: item[:name], description: item[:description], state: item[:state] })
  item[:stock_inventory_items].each do |stock_inventory_item|
    inventory_id = Inventory.find_by(code: stock_inventory_item[:code]).id
    raise "Inventory not found" if inventory_id.nil?

    StockInventoryItem.create(inventory_id: inventory_id, stock_id: stock.id, quantity: stock_inventory_item[:quantity])
  end
end
