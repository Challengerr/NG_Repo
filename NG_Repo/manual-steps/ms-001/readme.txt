1. Execute below script in Anonymous Apex to schedule Daily Job responsible for image fetch for NG_Component App.
Job will run daily at 10pm (22:00).



System.schedule('NG Component daily job', '0 0 22 * * ? *', new NG_ImageCalloutScheduler());