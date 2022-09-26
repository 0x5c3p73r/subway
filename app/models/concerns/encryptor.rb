# Inspried from https://gist.github.com/wteuber/5318013

require "openssl"

module Encryptor
  extend ActiveSupport::Concern

  ENCODER = "DES-EDE3-CBC"

  def generate_key(salt:, length: 8)
    length = 8 if length < 6
    key = Digest::MD5.hexdigest(salt)
    Digest::SHA1.base64digest(key).gsub(%r{[+\/=]}, "")[0..(length - 1)]
  end

  def encrypt(raw, private_key)
    cipher = OpenSSL::Cipher.new(ENCODER).encrypt
    cipher.key = encoded_private_key(private_key, length: 24)
    s = cipher.update(raw) + cipher.final

    s.unpack("H*")[0].upcase
  end

  def decrypt(private_key)
    cipher = OpenSSL::Cipher.new(ENCODER).decrypt
    cipher.key = encoded_private_key(private_key, length: 24)
    s = [raw].pack("H*").unpack("C*").pack("c*")

    cipher.update(s) + cipher.final
  end

  private

  def encoded_private_key(key, length:)
    Digest::SHA1.hexdigest(key)[0..(length - 1)]
  end

  class NotMatchedError < StandardError; end
end
