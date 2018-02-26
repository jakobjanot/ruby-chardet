# frozen_string_literal: true

require_relative "test_helper"

describe "Complete" do
  folders = Pathname.new(__dir__).join("assets").children.select(&:directory?)

  folders.each do |folder|
    encoding = \
      case folder.basename.to_s
      when "ASCII" then Encoding::ASCII
      when "BIG5" then Encoding::BIG5
      when "EUC-JP" then Encoding::EucJP
      when "EUC-KR" then Encoding::EucKR
      when "GB2312" then Encoding::GB2312
      when "IBM855" then Encoding::IBM855
      when "IBM866" then Encoding::IBM866
      when "ISO-8859-2-HUNGARIAN" then Encoding::ISO_8859_2
      when "ISO-8859-5-BULGARIAN" then Encoding::ISO_8859_5
      when "ISO-8859-5-CYRILLIC" then Encoding::ISO_8859_5
      when "ISO-8859-7-GREEK" then Encoding::ISO_8859_7
      when "KOI8-R" then Encoding::KOI8_R
      when "MacCyrillic" then Encoding::MacCyrillic
      when "SHIFT_JIS" then Encoding::Shift_JIS
      when "TIS-620" then Encoding::TIS_620
      when "UTF-8" then Encoding::UTF_8
      when "WINDOWS-1250-HUNGARIAN" then Encoding::CP1250
      when "WINDOWS-1251-BULGARIAN" then Encoding::CP1251
      when "WINDOWS-1251-CYRILLIC" then Encoding::CP1251
      when "WINDOWS-1255-HEBREW" then Encoding::CP1255
      else
        raise "Unknown encoding for folder: #{folder}"
      end
    files = folder.children.select { |entry| %w[.html .txt .xml].include? entry.extname }

    files.each do |file|
      it "parses #{encoding}:#{file.basename}" do
        detector = CharDet::UniversalDetector.new

        file.open("rb") do |fh|
          fh.readlines.each do |line|
            detector.feed(line)
            break if detector.done
          end
        end
        detector.close

        assert_equal encoding, detector.result[:encoding]
      end
    end
  end
end
