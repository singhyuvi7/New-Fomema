# password policies
@internalPasswordPolicy = PasswordPolicy.create!({
    name: "Internal User",
    require_alphabet: false,
    require_numeric: true,
    require_special_characters: false,
    require_small_and_capital: false,
    password_expiry: 1,
    block_previous_password: 3,
    status: "ACTIVE",
})

@externalPasswordPolicy = PasswordPolicy.create!({
    name: "External User",
    require_alphabet: false,
    require_numeric: true,
    require_special_characters: false,
    require_small_and_capital: false,
    password_expiry: 1,
    block_previous_password: 3,
    status: "ACTIVE",
})

puts "password policies seeded"