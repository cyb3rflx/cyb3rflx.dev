async function handler(event) {
    var request = event.request;
    var uri = request.uri
    var host = request.headers.host.value;
    var newurl = `https://cyb3rflx.dev${uri}`;
  
    if (host.startsWith("www.")) {
        var response = {
            statusCode: 301,
            statusDescription: 'Moved Permanently',
            headers:
                { "location": { "value": `${newurl}` } }
            }

        return response;
    }

    return request;
}

