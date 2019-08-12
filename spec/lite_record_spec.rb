RSpec.describe LiteRecord do
  let(:db) { LiteRecord::Base::DB }
  
  def create_user
    User.create('name' => 'john', 'email' => 'john@example.com')
  end

  class User < LiteRecord::Base
    self.table = 'users'
  end

  before do    
    db.execute('DROP TABLE IF EXISTS users;')
    db.execute('CREATE TABLE users (id INTEGER PRIMARY KEY, name varchar(15), email VARCHAR(30));')
  end

  it "has a version number" do
    expect(LiteRecord::VERSION).not_to be nil
  end

  describe "create" do
    it "succesffuly creates a record" do
      user = create_user

      expect(
        db.get_first_row('SELECT * from users order by id desc limit 1;')
      ).to eq(user.attributes)
    end
  end

  describe "find" do
    it "successfully finds a record with id" do
      id = create_user.attributes['id']

      expect(
        db.get_first_row('SELECT * from users order by id desc limit 1;')
      ).to eq(User.find(id).attributes)
    end
  end

  describe "count" do
    it "successfully counts the number of records" do
      5.times { create_user }
      
      expect(User.count).to eq(5)
    end
  end
end
