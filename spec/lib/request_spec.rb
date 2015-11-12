require 'spec_helper'

module DuoApi
  describe Request do
    describe ".request" do
      let(:instance) { double }

      before do
        expect(instance).to receive(:run).once
      end

      it "runs" do
        expect(Request).to receive(:new) { instance }.with(
          nil,
          DuoApi.config.hostname,
          "/auth/v2/check",
          nil,
          nil
        )
        Request.request("/auth/v2/check")
      end
    end

    describe "a request instance" do
      describe "properties" do
        describe "with mostly nils" do
          subject { Request.new(nil, DuoApi.config.hostname, "/a/path", nil, nil) }

          it "defaults the method" do
            expect(subject.method).to eq("GET")
          end

          it "defaults query string" do
            expect(subject.query_string).to eq("")
          end

          it "built a URI" do
            expect(subject.uri.to_s).to eq("https://non-existent.example.com/a/path")
          end

          it "built a signature" do
            expect(subject.signature.basic_auth).to be_an(Array)
            expect(subject.signature.basic_auth.length).to eq(2)
          end

          it "set headers" do
            expect(subject.headers["Date"]).to_not be_empty
          end
        end

        describe "with more options" do
          subject do
            Request.new(:post, DuoApi.config.hostname, "/a/path", { :foo => :bar }, { "X-Cool" => true })
          end

          it "defaults the method" do
            expect(subject.method).to eq("POST")
          end

          it "defaults query string" do
            expect(subject.query_string).to eq("foo=bar")
          end

          it "built a URI" do
            expect(subject.uri.to_s).to eq("https://non-existent.example.com/a/path")
          end

          it "built a signature" do
            expect(subject.signature.basic_auth).to be_an(Array)
            expect(subject.signature.basic_auth.length).to eq(2)
          end

          it "set headers" do
            expect(subject.headers["Date"]).to_not be_empty
            expect(subject.headers["X-Cool"]).to be_truthy
          end
        end

        describe "get with params" do
          subject do
            Request.new(:get, DuoApi.config.hostname, "/a/path", { :foo => :bar }, nil)
          end
          it "defaults query string" do
            expect(subject.query_string).to eq("foo=bar")
          end

          it "built a URI" do
            expect(subject.uri.to_s).to eq("https://non-existent.example.com/a/path?foo=bar")
          end
        end
      end
    end
  end
end
