FROM elixir:1.18

RUN apt-get update && \
    apt-get install -y \
      inotify-tools \
      fish \
      git \
    && rm -rf /var/lib/apt/lists/*

RUN mix local.hex --force && \
    mix local.rebar --force

WORKDIR /workspace

RUN groupadd --gid 1000 developer \
    && useradd --uid 1000 --gid 1000 \
        --create-home \
        --shell /usr/bin/fish \
        developer
        
USER developer

RUN fish # scafold default configs
COPY ./config.fish /home/developer/.config/fish/config.fish

CMD tail -f /dev/null