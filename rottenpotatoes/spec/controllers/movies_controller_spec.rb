require 'rails_helper'

describe MoviesController do
  
  describe 'GET new' do
    let!(:movie) { Movie.new }

    it 'should render the new template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe 'GET #edit' do
    let!(:movie) { FactoryGirl.create(:movie) }
    before do
      get :edit, id: movie.id
    end

    it 'should find the movie' do
      expect(assigns(:movie)).to eql(movie)
    end

    it 'should render the edit template' do
      expect(response).to render_template('edit')
    end
  end
   describe 'POST #create' do
    it 'creates a new movie' do
      expect {post :create, movie: FactoryGirl.attributes_for(:movie)
      }.to change { Movie.count }.by(1)
    end

    it 'redirects to the movie index page' do
      post :create, movie: FactoryGirl.attributes_for(:movie)
      expect(response).to redirect_to(movies_url)
    end
  end
  
  describe 'Search movies by the same director' do
    it 'should call Movie.similar_movies' do
      expect(Movie).to receive(:similar_movies).with('Aladdin')
      get :search, { title: 'Aladdin' }
    end

    it 'should assign similar movies if director exists' do
      movies = ['Seven', 'The Social Network']
      Movie.stub(:similar_movies).with('Seven').and_return(movies)
      get :search, { title: 'Seven' }
      expect(assigns(:similar_movies)).to eql(movies)
    end

    it "should redirect to home page if director isn't known" do
      Movie.stub(:similar_movies).with('No name').and_return(nil)
      get :search, { title: 'No name' }
      expect(response).to redirect_to(root_url)
    end
  end
  
  describe 'GET index' do
    let!(:movie) {FactoryGirl.create(:movie)}

    it 'should render the index template' do
      get :index
      expect(response).to render_template('index')
    end

    it 'should assign instance variable for title header' do
      get :index, { sort: 'title'}
      expect(assigns(:title_header)).to eql('hilite')
    end

    it 'should assign instance variable for release_date header' do
      get :index, { sort: 'release_date'}
      expect(assigns(:date_header)).to eql('hilite')
    end
  end
 
end
