require 'spec_helper'
describe "ReleaseScraper" do

  before :each do
    Artist.destroy_all
    Release.destroy_all
    @a = Artist.create!(:name => "Pompoduke", :sdid => 1, :fbid => "123")
    @rs = ReleaseScraper.new @a
  end

  def name_tester name, correct, increase = true
    rand = Random.rand(100000000)
    count = Release.count
    release = {
      "id" => rand,
      "title" => name,
      "releaseDate" => Date.today,
      "label" => {
        "name" => "Plums"
      }

    }
    @rs.sdigital_import [release], :test_mode => true
    @rs.save_all
    if increase
      Release.count.should == count+1
    else
      Release.count.should == count
    end
    r = Release.where(:sd_id => rand).first
    r.name.should == correct
  end

  it "improves names of remixes releases" do
    name_tester "Izzy Pop (Remixes)", "Izzy Pop"
    name_tester "Dizzy Trap (Radical Remixes)", "Dizzy Trap (Radical Remixes)"
    name_tester "Izzy Pop (Radical Remixes) EP", "Izzy Pop (Radical Remixes)"
    name_tester "Riggy Pop - EP", "Riggy Pop"
  end

  it "improves the name of an existing release" do
    old_release = @a.releases.build(:name => "You Should Know [Remixes]",:sd_id => 123, :date => Date.today, :scraped => true)
    old_release.save!
    
    @rs.improve_all
    Release.first.name.should == "You Should Know"
  end

  it "deletes duplicate releases" do
    old_release = @a.releases.build(:name => "You Should Know [Remixes]",:sd_id => 123, :date => Date.today, :scraped => true)
    old_release.save!
    old_release = @a.releases.build(:name => "You Should Know [Remixes]",:sd_id => 123, :date => Date.today, :scraped => true)
    old_release.save!
    Release.count.should == 2
    @rs.improve_all

  end

  it "gets last.fm artwork" do

  end

  it "skips bad itunes releases" do

  end

  it "gets the expected releases for an XML file" do

  end

end