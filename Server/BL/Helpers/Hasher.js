const crypto = require('crypto');
const key = process.env.ENCRYPTION_KEY || global.gConfig.EncodingKey ||"secret";
const algorithm = process.env.ENCRYPTION_ALGORITHM ||global.gConfig.EncodingAlg|| 'aes256';
const inputEncoding = process.env.ENCRYPTION_INPUT_ENCODING || global.gConfig.EncodingInEnc || 'utf8';
const outputEncoding = process.env.ENCRYPTION_OUTPUT_ENCODING || global.gConfig.EncodingOutEnc || 'hex';
// const saltRounds = 10000;
// const saltSize = 60;
// const saltGenerationSize = 128;
var digest = 'sha256';
var iterations = 99999;
var keyLength = 32;

// function Hash(value)
// {
//     var salt = crypto.randomBytes(saltGenerationSize).toString('base64').substr(0,saltSize);
//     var hash = crypto.pbkdf2(value, salt, saltRounds);
//     return salt+hash;  
// }

async function Hash(password) {
    var executor = function(resolve, reject) {
      var callback = function(error, salt) {
        if (error) {
          return reject(error);
        }
  
        var callback = function(error, key) {
          if (error) {
            return reject(error);
          }
  
          var buffer = new Buffer(keyLength * 2);
  
          salt.copy(buffer);
          key.copy(buffer, salt.length);
  
          resolve(buffer.toString('base64'));
        };
  
        crypto.pbkdf2(password, salt, iterations, keyLength, digest, callback);
      };
  
      crypto.randomBytes(keyLength, callback);
    };
  
    return new Promise(executor);
  };

// function Verify (value,hash)
// {
//     salt = hash.substr(0,saltSize);
//     hash = hash.substr(saltSize);
//     return savedHash == crypto.pbkdf2(value, savedSalt, saltRounds);
// }

async function Verify(password, hash) {
    var executor = function(resolve, reject) {
      var buffer = new Buffer(hash, 'base64');
      var salt = buffer.slice(0, keyLength);
      var keyA = buffer.slice(keyLength, keyLength * 2);
  
      var callback = function(error, keyB) {
        if (error) {
          return reject(error);
        }
  
        resolve(keyA.compare(keyB) == 0);
      };
  
      crypto.pbkdf2(password, salt, iterations, keyLength, digest, callback);
    };
  
    return new Promise(executor);
  };

function  EncodeValue(value)
{
    var cipher = crypto.createCipher(algorithm, key);
    var encrypted = cipher.update(value, inputEncoding, outputEncoding);
    encrypted += cipher.final(outputEncoding);
    return encrypted;
}

function DecodeValue(value)
{
    var decipher = crypto.createDecipher(algorithm, key);
    var decrypted = decipher.update(value, outputEncoding, inputEncoding);
    decrypted += decipher.final(inputEncoding);
    return decrypted;
}

module.exports = {Hash, Verify, EncodeValue, DecodeValue};