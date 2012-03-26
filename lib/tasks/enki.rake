namespace :enki do
  desc "Cleans out actions older than 7 days"
  task :clean_actions => :environment do
    UndoItem.delete_all(["created_at < ?", 7.days.ago])
  end
  desc "Set admin password"
  task :set_password => :environment do
    require "digest"
    print "Enter admin password: "
    pass = STDIN.gets().chomp!
    enki_config = YAML.load_file("#{Rails.root}/config/enki.yml")
    enki_config["author"]["passw"]= Digest::MD5.hexdigest(pass)
    File.open("#{Rails.root}/config/enki.yml", 'w') {|f| YAML.dump(enki_config,f)}
  end
end
