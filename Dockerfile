FROM alpine

RUN apk update && \
    apk add --no-cache wget curl python3 py3-pip && \
    pip install --upgrade pip && \
    mkdir -p $HOME/.aws

COPY requirements.txt .
COPY app.py .
COPY credentials $HOME/.aws/credentials
COPY main.tf .

RUN  pip install -r requirements.txt && \
     wget https://releases.hashicorp.com/terraform/0.15.0/terraform_0.15.0_linux_386.zip && \
     unzip terraform_0.15.0_linux_386.zip && \
     cp -rp terraform /usr/bin/terraform

#CMD [ "run", "--host=0.0.0.0" ]
CMD [ "python3", "./app.py" ]