combos = [
  {
    combo_id: 35,
    combo_name: "A Jazzy baby, A Crunchy Chicken & Fries ",
    children: [
      { product_id: 25, name: "Jazzy Baby", quantity: 1 },
      { product_id: 2, name: "Crunchy Chicken Burger", quantity: 1 },
      { product_id: 21, name: "French Fries", quantity: 1 }
    ]
  },
  {
    combo_id: 32,
    combo_name: "A Jazzy Baby, A Double Beef, & Fries",
    children: [
      { product_id: 25, name: "Jazzy Baby", quantity: 1 },
      { product_id: 6, name: "Double Beef Burger", quantity: 1 },
      { product_id: 21, name: "French Fries", quantity: 1 }
    ]
  },
  {
    combo_id: 29,
    combo_name: "Crunchy chicken x 2 Jazzy baby x2 Fries",
    children: [
      { product_id: 2, name: "Crunchy Chicken Burger", quantity: 2 },
      { product_id: 25, name: "Jazzy Baby", quantity: 2 },
      { product_id: 21, name: "French Fries", quantity: 1 }
    ]
  },
  {
    combo_id: 28,
    combo_name: "Single Beef x Fries x Jazzy Baby",
    children: [
      { product_id: 7, name: "Single Beef Burger", quantity: 1 },
      { product_id: 21, name: "French Fries", quantity: 1 },
      { product_id: 25, name: "Jazzy Baby", quantity: 1 }
    ]
  },
  {
    combo_id: 33,
    combo_name: "3x Jazzy Baby, 3x Crunchy Burger, 3x nuggets (5x) & 3x fries ",
    children: [
      { product_id: 25, name: "Jazzy Baby", quantity: 3 },
      { product_id: 2, name: "Crunchy Chicken Burger", quantity: 3 },
      { product_id: 12, name: "5x Chicken Nuggets", quantity: 3 },
      { product_id: 21, name: "French Fries", quantity: 3 }
    ]
  },
  {
    combo_id: 24,
    combo_name: "A Jazzy Baby & A Double Grilled Chicken burger",
    children: [
      { product_id: 25, name: "Jazzy Baby", quantity: 1 },
      { product_id: 3, name: "Double Grilled Chicken Burger", quantity: 1 },
      { product_id: 21, name: "French Fries", quantity: 1 }
    ]
  },
  {
    combo_id: 23,
    combo_name: "A Jazzy Baby & A Single Beef Burger",
    children: [
      { product_id: 25, name: "Jazzy Baby", quantity: 1 },
      { product_id: 7, name: "Single Beef Burger", quantity: 1 },
      { product_id: 21, name: "French Fries", quantity: 1 }
    ]
  },
  {
    combo_id: 30,
    combo_name: "Double Crunchy Chicken x Fries x Jazzy Baby",
    children: [
      { product_id: 5, name: "Double Crunchy Chicken Burger", quantity: 1 },
      { product_id: 21, name: "French Fries", quantity: 1 },
      { product_id: 25, name: "Jazzy Baby", quantity: 1 }
    ]
  },
  {
    combo_id: 22,
    combo_name: "2x Jazzy Baby & Grilled Chicken",
    children: [
      { product_id: 25, name: "Jazzy Baby", quantity: 2 },
      { product_id: 4, name: "Grilled Chicken Burger", quantity: 1 }
    ]
  }
]

combos.each do |combo|
  combo[:children].each do |child|
    next unless ComboProduct.find_by(combo_id: combo[:combo_id], product_id: child[:product_id]).blank?

    ComboProduct.create(
      combo_id: combo[:combo_id],
      product_id: child[:product_id],
      quantity: child[:quantity]
    )
  end
end
