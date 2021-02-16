User.create!(email: "user@example.com",
             password: "password",
             password_confirmation: "password",
             confirmed_at: Time.current)

User.create!(email: "guest@example.com",
             password: "password",
             password_confirmation: "password",
             confirmed_at: Time.current)

Micropost.create!(content: "今日から日記を始めることにする。",
                  user_id: 2,
                  created_at: Time.zone.today - 6)
Micropost.create!(content: "日記言うても今日はいつも通りで意外と書くこと特にないんだよな。",
                  user_id: 2,
                  created_at: Time.zone.today - 5)
Micropost.create!(content: "今日は一日中寝てた…結局睡眠こそが一番の娯楽な気がする。ぼーっとするのも良き。",
                  user_id: 2,
                  created_at: Time.zone.today - 4)
Micropost.create!(content: "ゲーム実況の動画見て久しぶりにやりたいなぁと思った。そういえば最近ゲームやらんようになったな…",
                  user_id: 2,
                  created_at: Time.zone.today - 3)
Micropost.create!(content: "最近は家にいるこた多かったから、久しぶりに散歩した。偶には外に出ないとな！",
                  user_id: 2,
                  created_at: Time.zone.today - 2)
Micropost.create!(content: "久しぶりにこたつにはいったら気持ち良く寝てしまった。人間はこたつの誘惑には勝てんのや。",
                  user_id: 2,
                  created_at: Time.zone.today - 1)
Micropost.create!(content: "急に暖かくなって温度差に違和感感じる。ここ数年冬の期間短いよなあ。",
                  user_id: 2,
                  created_at: Time.zone.today )