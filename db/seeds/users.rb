kl_branch = Organization.find_by(org_type: "BRANCH", code: 'KL')
title = Title.first
it_role = Role.find_by(code: 'IT_ADMIN')

# system users
[
    { username: "noreply", email: "noreply@fomema.com.my", name: "noreply" }
].each do |data|
    Organization.where(code: "HQ").first.create_user({
        skip_confirmation: true, 
        role_id: Role.where(code: "SYSTEM").first.id, 
        email: data[:email], 
        name: data[:username], 
        username: data[:username], 
        password: '12345678'
    }) if !User.where("email ilike ? or username ilike ?", data[:email], data[:username]).exists?
end

# IT users
[
    { username: "fonghy", email: "fonghy@bookdoc.com", name: "Fong" }, 
    { username: "fonghy2", email: "fonghy+2@bookdoc.com", name: "Fong 2" }, 
    { username: "mohamad", email: "mohamad@bookdoc.com", name: "Mohamad" }, 
    { username: "mohamad2", email: "mohamad+2@bookdoc.com", name: "Mohamad 2" }, 
    { username: "waynechang", email: "waynechang@bookdoc.com", name: "Wayne" }, 
    { username: "waynechang2", email: "waynechang+2@bookdoc.com", name: "Wayne 2" }, 
    { username: "joeychan", email: "joeychan@bookdoc.com", name: "Joey" }, 
    { username: "joeychan2", email: "joeychan+2@bookdoc.com", name: "Joey 2" }, 
    { username: "reuben", email: "reubenpoh@bookdoc.com", name: "Reuben" }, 
    { username: "reuben2", email: "reubenpoh+2@bookdoc.com", name: "Reuben 2" }, 
    { username: "yeewei", email: "yapyw@bookdoc.com", name: "YeeWei" }, 
    { username: "yeewei2", email: "yapyw+2@bookdoc.com", name: "YeeWei 2" }, 
    { username: "chongkh", email: "chongkh@bookdoc.com", name: "Chong" }, 
    { username: "chongkh2", email: "chongkh+2@bookdoc.com", name: "Chong 2" }, 
].each do |data|
    kl_branch.create_user(skip_confirmation: true, role_id: it_role.id, email: data[:email], name: data[:username], username: data[:username], password: '12345678') if !User.where("email ilike ? or username ilike ?", data[:email], data[:username]).exists?
end

puts "users seeded"