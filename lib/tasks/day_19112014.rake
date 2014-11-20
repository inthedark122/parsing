namespace :day19112014 do
  task :laki_kraski => :environment do
    m = Day19112014.new()
    m.laki_kraski()
  end

  task :poli => :environment do
    Day19112014.new().poli()
  end
  task :potolki => :environment do
    Day19112014.new().potolki()
  end
  task :kraski_smesi => :environment do
    Day19112014.new().kraski_smesi()
  end
  task :kirpich_keramika => :environment do
    Day19112014.new().kirpich_keramika()
  end
  task :facad => :environment do
    Day19112014.new().facad()
  end
  task :oboi => :environment do
    Day19112014.new().oboi()
  end

  task :eip => :environment do
    Day19112014.new().eip()
  end


end