
# import azure.functions as func

# from endpoint_runners.health_check_runner import HealthCheckRunner
# from framework.log_helper import LogHelper

# logger = LogHelper(__name__).logger

# def main(req: func.HttpRequest) -> func.HttpResponse:
#     logger.info("\n/health-check function recieved a request.")
#     HealthCheckRunner().run()
#     logger.info("/health-check function completed.\n")
    
#     return func.HttpResponse("Healthy!")

import logging
import json
import azure.functions as func

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')
    return func.HttpResponse(
        json.dumps({
            'method': req.method,
            'url': req.url,
            'headers': dict(req.headers),
            'params': dict(req.params),
            'get_body': req.get_body().decode()
        })
    )