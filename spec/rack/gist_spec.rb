require 'spec_helper'

describe Rack::Gist do
  include Rack::Test::Methods

  def generate_app(options={})
    body = options[:body]

    Rack::Lint.new(
      Rack::Gist.new(
        lambda do |env|
          [
            200,
            {'Content-Type' => 'text/html', 'Content-Length' => Rack::Utils.bytesize(body).to_s},
            [body]
          ]
        end
      )
    )
  end

  describe "a page with a gist in the body" do
    before do
      self.class.app = generate_app(body: '<p>Here is some text</p><p>https://gist.github.com/12345</p><p>Some more text</p>')
    end

    it "should parse out plain text gist links to js stylee" do
      get "/"
      body.should eql '<p>Here is some text</p><p><script src="https://gist.github.com/12345.js"></script></p><p>Some more text</p>'
    end
  end

  describe "a page with multiple gists in the body" do
    before do
      self.class.app = generate_app(body: '<p>Here is some text</p><p>https://gist.github.com/12345</p><p>https://gist.github.com/67</p><p>https://gist.github.com/8910</p><p>Some more text</p>')
    end

    it "should parse out plain text gist links to js stylee" do
      get "/"
      body.should eql '<p>Here is some text</p><p><script src="https://gist.github.com/12345.js"></script></p><p><script src="https://gist.github.com/67.js"></script></p><p><script src="https://gist.github.com/8910.js"></script></p><p>Some more text</p>'
    end
  end

  describe "a page with no gist in the body" do
    before do
      self.class.app = generate_app(body: '<p>Here is some text</p>><p>Some more text</p>')
    end

    it "should parse out plain text gist links to js stylee" do
      get "/"
      body.should eql '<p>Here is some text</p>><p>Some more text</p>'
    end
  end

  
end
