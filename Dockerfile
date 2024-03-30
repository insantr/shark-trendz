FROM mageai/mageai:latest

COPY ./mage/shark_trendz /home/src/shark_trendz

RUN pip3 install -r /home/src/shark_trendz/requirements.txt