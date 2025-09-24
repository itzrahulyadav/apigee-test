def invoke(request, response):
    message = "Hello from Python resource!"
    response.headers["X-Python-Message"] = message
    return response
