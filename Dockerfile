FROM ubuntu

RUN apt-get update && apt-get install -y libgfshare-bin par2
COPY . /code
CMD ["/code/tests/bats/bin/bats", "/code/tests/test.bats"]