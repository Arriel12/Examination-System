function addPropertyIfMissing(object,name,value)
{
    if(object[name]== undefined)
        object[name] = value;
}

module.exports = {addPropertyIfMissing};