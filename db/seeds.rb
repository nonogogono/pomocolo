User.create!(
  name:  "Example User",
  email: "example@railstutorial.org",
  password:              "foobar",
  password_confirmation: "foobar",
  confirmed_at: Time.zone.now
)

50.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(
    name:  name,
    email: email,
    password:              password,
    password_confirmation: password,
    confirmed_at: Time.zone.now
  )
end

users = User.order(:created_at).take(6)

# タスク
tasks = ["プログラミング（Ruby）", "プログラミング（Python）", "タイピング", "掃除", "洗濯", "料理", "パン作り", "園芸", "英会話", "国語", "数学", "英語", "日本史", "世界史", "地理", 
  "水泳", "ジョギング", "筋トレ", "テニス（サーブ）", "テニス（ストローク）", "読書", "ボイストレーニング", "ギター", "ベース", "ドラム", "ピアノ", "バンド練習", "作詞", "作曲", "編曲",
  "耳コピ", "ソルフェージュ", "簿記", "株", "習字（硬筆）", "習字（筆）", "釣り", "動画編集", "フォトショップ", "ネタ作り", "ネタ合わせ", "ロボットダンス", "日本舞踊", "ツーリング", "座禅"]

task_type = 9
users.each { |user|
  task_names = tasks.sample(task_type)
  task_type.times { |n|
    user.tasks.create!(name: task_names[n])
  }
}

# マイクロポスト
300.times { |n|
  users.each { |user|
    while true
      created_at = Time.zone.now.beginning_of_month.days_since(rand(0..30)) + (n/13).hours + (n/60).minutes + (n%60).seconds
      break if created_at < Time.zone.now
    end

    if n % 3 == 0
      task = nil
      task_time = nil
      if n % 100 < 10
        content = "#{Faker::Food.fruits} 食べたい"
      elsif n % 100 < 20
        content = "#{Faker::Space.planet} が見える"
        content += " 実はそこからきました" if n == 25
      elsif n % 100 < 30
        content = "最近 #{Faker::Vehicle.manufacture} から #{Faker::Vehicle.manufacture} に乗り替えました"
      elsif n % 100 < 40
        content = "#{Faker::Music::RockBand.name} はやはりかっこいい..."
      elsif n % 100 < 50
        content = "みんなで #{Faker::Beer.name} のみたい"
      elsif n % 100 < 60
        content = "#{Faker::JapaneseMedia::DragonBall.character} が一番強いとおもうなぁ。"
      elsif n % 100 < 70
        content = "#{Faker::Job.title} のお仕事に興味があります。"
      elsif n % 100 < 80
        content = "#{Faker::Science.scientist} のようになりたいものだ。"
      elsif n % 100 < 90
        content = "ウチの #{Faker::Creature::Dog.breed} の名前は #{Faker::Creature::Dog.name} です。よろしくね。"
      else
        content = "やせいの #{Faker::Games::Pokemon.name} があらわれた！"
      end
    else
      task = user.tasks[rand(0..task_type-1)].name
      task_time = 25
      if n % 11 == 0
        content = "ご飯食べてから続きをやろう..."
      elsif n % 7 == 0
        content = "もうそろそろ終わりそう！！"
      elsif n % 5 == 0
        content = "すごく集中できた！"
      elsif n % 4 == 0
        content = "あまり集中できなかった... そろそろ休憩しようかな。"
      else
        content = "進み具合はなかなかかな？"
      end
    end

    user.microposts.create!(
      content: content,
      created_at: created_at,
      task: task,
      task_time: task_time
    )
  }
}

# リレーションシップ
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
