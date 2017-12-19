FROM thomasp85/firedock_test

ARG root='/'
ENV FIERY_ROOT=$root


## Switch from root
RUN useradd --create-home --shell /bin/bash ruser
USER ruser
WORKDIR /home/ruser

ADD firedock /home/ruser/

RUN R CMD build firedock

EXPOSE 8080

CMD ["Rscript", "-e 'firedock::app$ignite()'"]
