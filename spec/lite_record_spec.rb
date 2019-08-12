RSpec.describe LiteRecord do
  let(:db) { LiteRecord::Base::DB }

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
      user = User.create('name' => 'john', 'email' => 'john@example.com')

      expect(
        db.get_first_row('SELECT * from users order by id desc limit 1;')
      ).to eq(user.attributes)
    end
  end

  describe "find" do
    it "successfully finds a record with id" do
      id = User.create('name' => 'john', 'email' => 'john@example.com').attributes['id']

      expect(
        db.get_first_row('SELECT * from users order by id desc limit 1;')
      ).to eq(User.find(id).attributes)
    end
  end
end
