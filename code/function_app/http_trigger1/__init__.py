
import logging
import json
import time
import azure.functions as func
from . import toolsA_F1 as tools

def main(req: func.HttpRequest) -> func.HttpResponse:
    start = time.time()
    logging.info('Python HTTP trigger function processed a request.')

    try:
        # Decode and return request body as JSON
        req_body = req.get_json()
    except ValueError:
        numA, numB = None, None
        pass
    else:
        numA = req_body.get('A')
        numB = req_body.get('B')        


    if numA and numB:
        # Call Common Functions
        sum1 = tools.sum1(numA, numB)
        sub1 = tools.sub1(numA, numB)
        pow1 = tools.pow1(numA, numB)
        div1 = tools.div1(numA, numB)

        dt1 = time.time()-start
        return func.HttpResponse(
            json.dumps({
                'method': req.method,
                'url': req.url,
                'headers': dict(req.headers),
                'params': dict(req.params),
                'get_body': req.get_body().decode(),
                'timer': dt1,
                'return': 'Function App recieved %s and %s' %({numA}, {numB}) ,
                'Sum': sum1,
                'Sub': sub1,
                'Pow': pow1,
                'Div': div1
            })
            )

    else:
        dt1 = time.time()-start
        return func.HttpResponse(
            json.dumps({
                'method': req.method,
                'url': req.url,
                'headers': dict(req.headers),
                'params': dict(req.params),
                'get_body': req.get_body().decode(),
                'timer': dt1,
                'return': 'Please pass numbers A,B to Function App in the request body'
            })
            , status_code=400
        )
