# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# :id=>"scrum-team-admins-host:babynames"
# "scrum-team-admins-host"
project_id       = attribute('dataset_project')
dataset_id       = attribute('dataset_id')
table_id         = attribute('table_id')

control "big_query_check" do

  # Checking the default files exist in the module root
  describe file("config.tf") do
    it { should exist }
  end

  describe file("main.tf") do
    it { should exist }
  end

  describe file("variables.tf") do
    it { should exist }
  end

  describe file("outputs.tf") do
    it { should exist }
  end

  describe command("bq ls --project_id=#{project_id} --format=json") do
     its('exit_status') { should be 0 }
     its('stderr') { should eq '' }

     let(:metadata) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout, symbolize_names: true).to_s
      else
        {}
      end
     end
     it { expect(metadata).to be_a_kind_of(String) }
     it { expect(metadata).to include("#{dataset_id}") }
   end

   describe command("bq ls --project_id=#{project_id} --format=json #{dataset_id}" ) do
      its('exit_status') { should be 0 }
      its('stderr') { should eq '' }

      let(:metadata) do
       if subject.exit_status == 0
         JSON.parse(subject.stdout, symbolize_names: true).to_s
       else
         {}
       end
      end
      it { expect(metadata).to be_a_kind_of(String) }
      it { expect(metadata).to include("#{table_id}") }
    end
end
