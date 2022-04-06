namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development? 
      show_spinner("Dropando DB...") { %x(rails db:drop:_unsafe) }

      show_spinner("Criando DB...")  { %x(rails db:create)}
      
      show_spinner("Migrando DB...") { %x(rails db:migrate)}
      
      %x(rails dev:add_mining_types)

      %x(rails dev:add_coins)
      
      
    else
      puts "você não está em ambiente de desenvolvimento"
    end
  end
  
  
  desc "Cadastro de moedas"
  task add_coins: :environment do
    show_spinner("Criando Moedas...") do
      coins = [
                 {
                     description: "Bitcoin",
                     acronym: "BTC",
                     url_image: "https://imagensemoldes.com.br/wp-content/uploads/2020/09/Logo-Bitcoin-PNG.png",
                     mining_type: MiningType.find_by(acronym: 'PoW')
                 },
                 {
                     description: "Ethereum",
                     acronym: "ETH",
                     url_image: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/ETHEREUM-YOUTUBE-PROFILE-PIC.png/600px-ETHEREUM-YOUTUBE-PROFILE-PIC.png",
                     mining_type: MiningType.all.sample
                 },
                 {
                     description: "Dash",
                     acronym: "DASH",
                     url_image: "https://www.pngall.com/wp-content/uploads/10/Dash-Crypto-Logo-No-Background.png",
                     mining_type: MiningType.all.sample
                 }
             ]
      coins.each do |coin|
         Coin.find_or_create_by!(coin)
      end
    end
  end
  
  
  desc "Cadastro dos tipos de mineração"
  task add_mining_types: :environment do
    show_spinner("Criando Tipos de Mineração...") do
      mining_types = [
                 {description: "Proof of Work", acronym: "PoW"},
                 {description: "Proof of Stake", acronym: "PoS"},
                 {description: "Proof of Capacity",acronym: "PoC"}
             ]
      mining_types.each do |mining_type|
         MiningType.find_or_create_by!(mining_type)
      end
    end
  end
   

 

  def show_spinner(msg_start, msg_end='Sucesso')
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin  
    yield
    spinner.success("(#{msg_end})")
  end
  
  
end
