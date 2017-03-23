# Brand.create([
#   {name: "13 Fishing"},
#   {name: "Abu Garcia"},
#   {name: "Ardent"},
#   {name: "Berkley"},
#   {name: "Castaway"},
#   {name: "Daiwa"},
#   {name: "Denali Rods"},
#   {name: "Dobyns Rods"},
#   {name: "Duckett Fishing"},
#   {name: "Falcon"},
#   {name: "Fenwick"},
#   {name: "G. Loomis"},
#   {name: "Halo Fishing"},
#   {name: "Jackall"},
#   {name: "Lew's"},
#   {name: "Megabass"},
#   {name: "Okuma"},
#   {name: "Quantum"},
#   {name: "St. Croix"},
#   {name: "Other"}
# ])
#
# Brand.create([
#   {name: "Offshore Angler"},
#   {name: "Abu Garcia"},
#   {name: "Penn"},
#   {name: "Accurate"},
#   {name: "Fin-Nor"},
#   {name: "Daiwa"},
#   {name: "Lew's"},
#   {name: "Okuma"},
#   {name: "Quantum"},
#   {name: "Other"}
# ])
#
# Category.create([
#   {name: "Reels"},
#   {name: "Rods"},
#   {name: "Lures"},
#   {name: "General"},
#   {name: "Apparel"},
#   {name: "Boating"},
#   {name: "Electronics"},
#   {name: "Freshwater"},
#   {name: "Saltwater"},
# ])
#
# User.create([
#   {email: "bob@example.com", password: "123456789"},
#   {email: "larry@example.com", password: "123456789"},
#   {email: "sam@example.com", password: "123456789"},
#   {email: "joe@example.com", password: "123456789"},
#   {email: "john@example.com", password: "123456789"}
# ])

file  = File.open(File.join(Rails.root,'app/assets/images/rs (4).jpeg'))

Product.create([
  {
    name: "Lew's Speed Spool",
    description: "Bacon ipsum dolor amet ribeye biltong pork chuck. Shankle meatloaf porchetta bacon short ribs swine kielbasa, corned beef turkey. Leberkas tri-tip landjaeger pork. Landjaeger turkey cupim sirloin short loin rump, chuck tongue.",
    price: 100.50,
    user_id: 1,
    display_image: file
  },
  {
    name: "Shimano Citica",
    description: "Bacon ipsum dolor amet ribeye biltong pork chuck. Shankle meatloaf porchetta bacon short ribs swine kielbasa, corned beef turkey. Leberkas tri-tip landjaeger pork. Landjaeger turkey cupim sirloin short loin rump, chuck tongue.",
    price: 150.50,
    user_id: 2,
    display_image: file
  },
  {
    name: "Abu Garcia Revo",
    description: "Bacon ipsum dolor amet ribeye biltong pork chuck. Shankle meatloaf porchetta bacon short ribs swine kielbasa, corned beef turkey. Leberkas tri-tip landjaeger pork. Landjaeger turkey cupim sirloin short loin rump, chuck tongue.",
    price: 200.50,
    user_id: 3,
    display_image: file
  },
  {
    name: "Abu Garcia Revo",
    description: "Bacon ipsum dolor amet ribeye biltong pork chuck. Shankle meatloaf porchetta bacon short ribs swine kielbasa, corned beef turkey. Leberkas tri-tip landjaeger pork. Landjaeger turkey cupim sirloin short loin rump, chuck tongue.",
    price: 200.50,
    shipping: 10.00,
    user_id: 4,
    display_image: file
  },
  {
    name: "Abu Garcia Revo",
    description: "Bacon ipsum dolor amet ribeye biltong pork chuck. Shankle meatloaf porchetta bacon short ribs swine kielbasa, corned beef turkey. Leberkas tri-tip landjaeger pork. Landjaeger turkey cupim sirloin short loin rump, chuck tongue.",
    price: 200.50,
    shipping: 10.00,
    user_id: 5,
    display_image: file
  },
])
