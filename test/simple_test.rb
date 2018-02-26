# frozen_string_literal: true

require_relative "test_helper"

describe "Simple" do
  def simple_assets_path
    Pathname.new("test").join("simple_assets")
  end

  it "detects UTF-7" do
    assert_equal(
      { encoding: Encoding::UTF_7, confidence: 0.99 },
      CharDet.detect(simple_assets_path.join("UTF-7.txt").open("rb", &:read))
    )
  end

  it "detects EUC_JP" do
    assert_equal(
      { encoding: Encoding::EucJP, confidence: 0.99 },
      CharDet.detect(simple_assets_path.join("EUC-JP.txt").open("rb", &:read))
    )
  end

  it "detects Shift_JIS" do
    assert_equal(
      { encoding: Encoding::SHIFT_JIS, confidence: 0.99 },
      # TODO: the 1.9 value might be wrong but I cannot find any bug
      CharDet.detect(simple_assets_path.join("Shift_JIS.txt").open("rb", &:read))
    )
  end

  it "detects Shift_JIS from short string" do
    CharDet.detect("日本語".encode("Shift_JIS"))[:encoding].must_equal Encoding::SHIFT_JIS
  end

  it "detects Shift_JIS from more than four characters" do
    CharDet.detect("四文字以上の日本語".encode("Shift_JIS"))[:encoding].must_equal Encoding::SHIFT_JIS
  end

  it "detects Shift_JIS from Japanese and ASCII characters" do
    CharDet.detect("日本語 and ASCII characters".encode("Shift_JIS"))[:encoding].must_equal \
      Encoding::SHIFT_JIS
  end

  it "detects UTF_8" do
    assert_equal(
      { encoding: Encoding::UTF_8, confidence: 0.99 },
      CharDet.detect(simple_assets_path.join("UTF-8.txt").open("rb", &:read))
    )
  end

  it "detects eucJP_ms" do
    assert_equal(
      { encoding: Encoding::EucJP, confidence: 0.99 },
      CharDet.detect(simple_assets_path.join("eucJP-ms.txt").open("rb", &:read))
    )
  end

  it "detects UTF_16BE" do
    assert_equal(
      { encoding: Encoding::UTF_16BE, confidence: 1 },
      CharDet.detect(simple_assets_path.join("UTF-16BE.txt").open("rb", &:read))
    )
  end

  it "detects UTF_16LE" do
    assert_equal(
      { encoding: Encoding::UTF_16LE, confidence: 1 },
      CharDet.detect(simple_assets_path.join("UTF-16LE.txt").open("rb", &:read))
    )
  end

  it "detects ISO_2022_JP" do
    assert_equal(
      { encoding: Encoding::ISO_2022_JP, confidence: 0.99 },
      CharDet.detect(simple_assets_path.join("ISO-2022-JP.txt").open("rb", &:read))
    )
  end

  it "detects big5" do
    assert_equal(
      { encoding: Encoding::BIG5, confidence: 0.99 },
      CharDet.detect(simple_assets_path.join("big5.txt").open("rb", &:read))
    )
  end

  it "detects russian" do
    # this failed when using $KCODE='u' on 1.8 ... just making sure it stays put
    CharDet.detect(
      "Toto je zpr\xE1va ve form\xE1tu MIME s n\xECkolika \xE8\xE1stmi.\n"
    )[:encoding].must_equal Encoding::CP1251
  end

  it "detects what is likely to be ISO-8859-2 w/ garbage chars" do
    bad = "Colegio Nuestra Se\xcc\xb1ora Del Rosario"
    CharDet.detect(bad)[:encoding].must_equal Encoding::ISO_8859_2
  end

  it "does not blow up on invalid encoding" do
    bad = "bad encoding: \xc3\x28"
    CharDet.detect(bad)[:encoding].must_equal Encoding::ISO_8859_2
    bad.encoding.must_equal Encoding::UTF_8
  end

  it "does not blow up on multibyte UTF-8 chars" do
    accented = "Juan Pérez"
    CharDet.detect(accented)[:encoding].must_equal Encoding::ISO_8859_2
    accented.encoding.must_equal Encoding::UTF_8
  end
end
