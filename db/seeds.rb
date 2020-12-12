User.create!(email: "user@example.com",
             password: "password",
             password_confirmation: "password",
             confirmed_at: Date.today)

User.create!(email: "guest@example.com",
             password: "password",
             password_confirmation: "password",
             confirmed_at: Date.today)
