# loader - basically to read notes
module Kernel
  def all_databases
    [$data_actors,$data_classes,$data_skills,$data_items,$data_weapons,$data_armors,$data_enemies,
    $data_troops, $data_states, $data_animations, $data_tilesets
    ]
  end
end


class << DataManager
  alias load_normal_database_loader load_normal_database
  def load_normal_database
    load_normal_database_loader
    eval_all_notes
    create_empty_databases
  end
  
  
  # the main method
  def eval_all_notes
    all_databases.each do |database|
      database.compact.each do |i|
        i.eval_notes if i.respond_to? :eval_notes
      end # each i
    end # each database
    
    
    def create_empty_databases
      $data_materials = {}
      $data_items.compact.each do |i|
        $data_materials[i.material.label] = i.material if i.material
      end
      puts $data_materials
    end
    
    
  end # def
end