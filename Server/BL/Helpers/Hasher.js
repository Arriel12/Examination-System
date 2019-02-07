const crypto = require('crypto');
const key = process.env.ENCRYPTION_KEY || global.gConfig.EncodingKey ||"secret";
const algorithm = process.env.ENCRYPTION_ALGORITHM ||global.gConfig.EncodingAlg|| 'aes256';
const inputEncoding = process.env.ENCRYPTION_INPUT_ENCODING || global.gConfig.EncodingInEnc || 'utf8';
const outputEncoding = process.env.ENCRYPTION_OUTPUT_ENCODING || global.gConfig.EncodingOutEnc || 'hex';
const saltRounds = 10000;
const saltSize = 60;
const saltGenerationSize = 128;

function Hash(value)
{
    var salt = crypto.randomBytes(saltGenerationSize).toString('base64').substr(0,saltSize);
    var hash = pbkdf2(value, salt, saltRounds);

    return salt+hash;
    
}

function Verify (value,hash)
{
    salt = hash.substr(0,saltSize);
    hash = hash.substr(saltSize);
    return savedHash == pbkdf2(value, savedSalt, saltRounds)
}

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
    var decrypted = decipher.update(encrypted, outputEncoding, inputEncoding);
    decrypted += decipher.final(inputEncoding);
    return decrypted;
}

module.exports = {Hash, Verify, EncodeValue, DecodeValue};