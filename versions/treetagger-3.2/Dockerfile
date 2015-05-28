# TreeTagger
#
# @version 	latest (3.2)
# @author 	leodido <leodidonato@gmail.com> (@leodido)
FROM gliderlabs/alpine:3.1
ADD /treetagger.tar.gz /usr/local/
RUN apk --update add perl && chmod +x /usr/local/cmd/*
ENV PATH $PATH:/usr/local/cmd