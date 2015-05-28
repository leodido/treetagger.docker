# TreeTagger
#
# @author 	leodido <leodidonato@gmail.com> (@leodido)
FROM debian:wheezy
MAINTAINER Leonardo Di Donato <leodidonato@gmail.com> (@leodido)
RUN apt-get update && apt-get install -y curl
COPY scripts/make.bash scripts/install.bash /
ENTRYPOINT ["/make.bash"]