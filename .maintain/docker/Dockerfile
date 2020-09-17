FROM phusion/baseimage:0.11 as builder

ARG PROFILE=release
WORKDIR /nodle-chain-collator

COPY . /nodle-chain-collator

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y cmake pkg-config libssl-dev git clang
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
	export PATH=$PATH:$HOME/.cargo/bin && \
	scripts/init.sh && \
	cargo build -p nodle-chain-collator --$PROFILE

# ===== SECOND STAGE ======

FROM phusion/baseimage:0.11

ARG PROFILE=release

COPY --from=builder /nodle-chain-collator/target/$PROFILE/nodle-chain-collator /usr/local/bin

RUN apt-get update && \
	apt-get upgrade -y

RUN mv /usr/share/ca* /tmp && \
	rm -rf /usr/share/*  && \
	mv /tmp/ca-certificates /usr/share/ && \
	rm -rf /usr/lib/python* && \
	useradd -m -u 1000 -U -s /bin/sh -d /nodle-chain-collator nodle-chain-collator && \
	mkdir -p /nodle-chain-collator/.local/share/nodle-chain-collator && \
	chown -R nodle-chain-collator:nodle-chain-collator /nodle-chain-collator/.local && \
	ln -s /nodle-chain-collator/.local/share/nodle-chain-collator /data

USER nodle-chain-collator
EXPOSE 30333 9933 9944
VOLUME ["/data"]

ENTRYPOINT ["/usr/local/bin/nodle-chain-collator-collator"]
