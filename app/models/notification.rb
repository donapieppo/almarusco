class Notification
  attr_accessor :from, :to, :subject

  def initialize(organizations)
    @organizations = organizations || Organization.all
  end

  def send
    @organizations.each do |organization|
      puts "---- analizzo: #{organization} dalla data #{@from} -----"

      # prima riempio con elenco di tutti gli scarichi diviso per utente
      all_unloads = Hash.new { |hash, key| hash[key] = "" }

      organization.disposals.where(['approved_at >= ?', @from])
                            .includes(:user, disposal_type: [:cer_code, :un_code, :hp_codes, :adrs]).each do |disposal|
        to    = disposal.user        
        data  = unload.date.strftime("%d/%m/%Y")
        all_unloads[to] += " #{data} - #{num}  #{thing} #{note} #{operator}\n"
      end

      all_unloads.each do |user, elenco|
        puts "Trovato #{user.inspect} con i seguenti unloads:"
        puts elenco
        SystemMailer.notify_unloads(user, organization, @from, @to, @subject, elenco).deliver_now
      end
    end
  end
end
