namespace :almarusco do
  desc "checks"
  task checks: :environment do
    # "created_at" "approved_at" "legalized_at" "delivered_at" "completed_at"
    d = Disposal.where("created_at > approved_at or approved_at > legalized_at or legalized_at > delivered_at or delivered_at > completed_at")
    if d.any?
      p "Ci sono rifiuti con ordine delle date sbagliato"
      d.each do |x|
        p x
      end
    end

    d = Disposal.where("legalized_at > delivered_at")
    if d.any?
      p "Ci sono rifiuti accettati dopo la consegna"
      p d
    end

    d = Disposal.where("kgs = 0 and approved_at is not null")
    if d.any?
      p "Ci sono rifiuti accettati senza peso"
      p d
    end
  end
end
