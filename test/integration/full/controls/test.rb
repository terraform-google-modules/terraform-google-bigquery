control "config_tf_check" do
  describe file("config.tf") do
    it { should exist }
  end
end
