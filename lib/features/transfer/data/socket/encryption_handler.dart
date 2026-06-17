import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';

/// AES-256-GCM encryption for per-chunk transfer security.
///
/// Each chunk is encrypted with a unique IV derived from the chunk index.
/// The authentication tag ensures data integrity and prevents tampering.
///
/// Encrypted format: [12-byte IV] + [ciphertext] + [16-byte auth tag]
class EncryptionHandler {
  EncryptionHandler(this._key);

  final Uint8List _key; // 32 bytes (AES-256)

  /// Generate a new random 256-bit key.
  factory EncryptionHandler.generate() {
    final rng = SecureRandom('Fortuna')
      ..seed(KeyParameter(_randomSeed()));
    return EncryptionHandler(rng.nextBytes(32));
  }

  /// Get the raw key bytes (for key exchange).
  Uint8List get keyBytes => Uint8List.fromList(_key);

  /// Encrypt a chunk using AES-256-GCM.
  ///
  /// Returns: [12-byte IV] + [ciphertext] + [16-byte auth tag]
  Uint8List encryptChunk(Uint8List plaintext, int chunkIndex) {
    final iv = _deriveIv(chunkIndex);
    final aad = _buildAad(chunkIndex);

    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        true, // encrypt
        AEADParameters(
          KeyParameter(_key),
          128, // 16-byte auth tag
          iv,
          aad,
        ),
      );

    final ciphertext =
        Uint8List(cipher.getOutputSize(plaintext.length));
    final len = cipher.processBytes(
        plaintext, 0, plaintext.length, ciphertext, 0);
    cipher.doFinal(ciphertext, len);

    // Result: IV + ciphertext (includes appended auth tag)
    final result = Uint8List(iv.length + ciphertext.length);
    result.setRange(0, iv.length, iv);
    result.setRange(iv.length, result.length, ciphertext);
    return result;
  }

  /// Decrypt a chunk.
  ///
  /// Input: [12-byte IV] + [ciphertext] + [16-byte auth tag]
  Uint8List decryptChunk(Uint8List encrypted, int chunkIndex) {
    final iv = Uint8List.sublistView(encrypted, 0, 12);
    final ciphertextWithTag = Uint8List.sublistView(encrypted, 12);
    final aad = _buildAad(chunkIndex);

    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        false, // decrypt
        AEADParameters(
          KeyParameter(_key),
          128,
          iv,
          aad,
        ),
      );

    final plaintext =
        Uint8List(cipher.getOutputSize(ciphertextWithTag.length));
    final len = cipher.processBytes(
        ciphertextWithTag, 0, ciphertextWithTag.length, plaintext, 0);
    cipher.doFinal(plaintext, len);

    return plaintext;
  }

  /// Encrypt the AES key using a shared secret (for key exchange).
  /// Simple XOR-based wrapping with the shared secret hash.
  Uint8List exportKey(Uint8List sharedSecret) {
    final wrapper = _deriveWrapper(sharedSecret);
    final result = Uint8List(_key.length);
    for (int i = 0; i < _key.length; i++) {
      result[i] = _key[i] ^ wrapper[i % wrapper.length];
    }
    return result;
  }

  /// Import a key decrypted with a shared secret.
  factory EncryptionHandler.fromEncryptedKey(
      Uint8List encryptedKey, Uint8List sharedSecret) {
    final wrapper = _deriveWrapper(sharedSecret);
    final key = Uint8List(encryptedKey.length);
    for (int i = 0; i < encryptedKey.length; i++) {
      key[i] = encryptedKey[i] ^ wrapper[i % wrapper.length];
    }
    return EncryptionHandler(key);
  }

  // ── Internals ─────────────────────────────────────────────────────────────

  /// Derive a deterministic 12-byte IV from the chunk index.
  Uint8List _deriveIv(int chunkIndex) {
    final iv = Uint8List(12);
    final bd = ByteData.sublistView(iv);
    bd.setUint32(0, chunkIndex, Endian.big);
    // Mix in some key material to avoid IV reuse across transfers.
    for (int i = 4; i < 12; i++) {
      iv[i] = _key[i % _key.length];
    }
    return iv;
  }

  /// Build AAD (Additional Authenticated Data) binding ciphertext to position.
  Uint8List _buildAad(int chunkIndex) {
    final aad = Uint8List(4);
    ByteData.sublistView(aad).setUint32(0, chunkIndex, Endian.big);
    return aad;
  }

  static Uint8List _deriveWrapper(Uint8List sharedSecret) {
    final digest = SHA256Digest();
    final hash = Uint8List(digest.digestSize);
    digest.update(sharedSecret, 0, sharedSecret.length);
    digest.doFinal(hash, 0);
    return hash;
  }

  static Uint8List _randomSeed() {
    final rng = Random.secure();
    return Uint8List.fromList(
        List<int>.generate(32, (_) => rng.nextInt(256)));
  }
}
