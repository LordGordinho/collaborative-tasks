require 'rails_helper'

RSpec.describe 'Task API' do
  before { host! 'localhost' }

  let!(:user) { create(:user) }
  let(:list) { create(:list, user: user) }
  let!(:auth_data) { user.create_new_auth_token }
  let(:headers) do
		{
		  'Content-Type' => Mime[:json].to_s,
		  'access-token' => auth_data['access-token'],
		  'uid' => auth_data['uid'],
		  'client' => auth_data['client']
		}
  end

  describe 'GET /lists' do
    context 'when no filter param is sent' do
      before do
        create_list(:list, 5, user_id: user.id )
        get '/lists', params: {}, headers: headers
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns 5 lists from database' do
        expect(json_body[:lists].count).to eq(5)
      end      
    end
  end


  describe 'GET /lists/:id' do
    let(:list) { create(:list, user_id: user.id) }

    before { get "/lists/#{list.id}", params: {}, headers: headers }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns the json for list' do
      expect(json_body[:list][:name]).to eq(list.name)
    end
  end


  describe 'POST /lists' do
    before do
      post '/lists', params: { list: list_params }.to_json, headers: headers
    end

    context 'when the params are valid' do
      let(:list_params) { attributes_for(:list) }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'saves the list in the database' do
        expect( List.find_by(name: list_params[:name]) ).not_to be_nil
      end

      it 'returns the json for created task' do
        expect(json_body[:list][:name]).to eq(list_params[:name])
      end

      it 'assigns the created task to the current user' do
        expect(json_body[:list][:user_id]).to eq(user.id)
      end      
    end

    context 'when the params are invalid' do
      let(:list_params) { attributes_for(:list, name: ' ') }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'does not save the task in the database' do
        expect( List.find_by(name: list_params[:name]) ).to be_nil
      end

      it 'returns the json error for title' do
        expect(json_body[:errors]).to have_key(:name)
      end
    end
  end

  
  describe 'PUT /lists/:id' do
    let!(:list) { create(:list, user_id: user.id) }

    before do
      put "/lists/#{list.id}", params: { list: list_params }.to_json, headers: headers
    end

    context 'when the params are valid' do
      let(:list_params){ { name: 'New task title' } }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the json for updated list' do
        expect(json_body[:list][:name]).to eq(list_params[:name])
      end

      it 'updates the list in the database' do
        expect( List.find_by(name: list_params[:name]) ).not_to be_nil
      end
    end

    context 'when the params are invalid' do
      let(:list_params){ { name: ' '} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns the json error for name' do
        expect(json_body[:errors]).to have_key(:name)
      end

      it 'does not update the list in the database' do
        expect( List.find_by(name: list_params[:name]) ).to be_nil
      end
    end
  end


  describe 'DELETE /lists/:id' do
    let!(:list) { create(:list, user_id: user.id) }

    before do
      delete "/lists/#{list.id}", params: {}, headers: headers
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the list from the database' do
      expect { List.find(list.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'GET /lists/:id/get_all_tasks_on_list' do
    let!(:list_2) { create(:list, user_id: user.id)}
    let!(:task) { create(:task , user_id: user.id, list_id: list_2.id) }
    let!(:user_2) { create(:user)}
    let!(:task_2) { create(:task , user_id: user_2.id, list_id: list_2.id)}

    before { get "/lists/#{list_2.id}/get_all_tasks_on_list/", params: {}, headers: headers }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns the json for tasks' do
      expect(json_body[:tasks].count).to eq(2)
    end
  end
  
  describe 'GET /lists/:id/get_all_users_of_list' do
    let!(:list_2) { create(:list, user_id: user.id)}
    let!(:task) { create(:task , user_id: user.id, list_id: list_2.id) }
    let!(:user_2) { create(:user)}
    let!(:task_2) { create(:task , user_id: user_2.id, list_id: list_2.id)}
    let!(:task_3) { create(:task , user_id: user_2.id, list_id: list_2.id)}
    
    before { get "/lists/#{list_2.id}/get_all_users_of_list/", params: {}, headers: headers }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns the json for users' do
      expect(json_body[:users].count).to eq(2)
    end
  end
end
