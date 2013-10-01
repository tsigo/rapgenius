require 'spec_helper'

module RapGenius
  describe Lyric do
    let(:normal_line) { "[Verse 1]" }
    let(:annotated_line) do
      "<a data-id=\"2092854\" data-editorial-state=\"accepted\" " +
      "href=\"/2092854/Big-sean-control/Its-strictly-by-faith-that-we-made-it-this-far\">" +
      "It\u2019s strictly by faith that we made it this far</a>"
    end

    describe "#annotated?" do
      it "returns true when lyric is annotated" do
        lyric = Lyric.new(annotated_line)
        lyric.should be_annotated
      end

      it "returns false when lyric is not annotated" do
        lyric = Lyric.new(normal_line).should_not be_annotated
      end
    end

    describe "#annotation" do
      it "should raise LyricError when lyric is not annotated" do
        expect { Lyric.new(normal_line).annotation }.to raise_error(LyricError)
      end

      it "should return the corresponding Annotation object" do
        obj = Lyric.new(annotated_line).annotation
        obj.should be_an Annotation
        obj.id.should eq "2092854"
      end
    end
  end
end
