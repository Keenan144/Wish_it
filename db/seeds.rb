User.create(handle: "keenan", password: "12345", name: "Keenan Sturtevant", gender: "male", age: 20)
User.create(handle: "mom", password: "12345", name: "Zambrina Sturtevant", gender: "female", age: 42)


@counter = 3

3.times do |wish|
  @counter += 1
  Wish.create(content: "Two front Teeth!", user_id: @counter)
end
