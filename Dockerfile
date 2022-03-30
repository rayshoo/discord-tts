FROM python:3.9
RUN pip install -U pip

RUN apt-get update && apt-get upgrade -y && apt-get install -y ffmpeg espeak make gcc git

RUN git clone https://github.com/vishnubob/wait-for-it wait-for-it && \
    cd wait-for-it && chmod +x wait-for-it.sh && mv wait-for-it.sh / && \
    cd / && rm -rf wait-for-it

# Deprecated git protocol fix
# https://github.com/rayshoo/aiohttp/commit/bd45f08a2a2991cd2b9ba1499f9f36918277d965
RUN git clone https://github.com/rayshoo/aiohttp aiohttp-git && cd aiohttp-git && \
    git checkout discord && \
    git submodule update --init && make cythonize && cd /

RUN git clone https://github.com/numediart/MBROLA MBROLA && \
    cd MBROLA && make && mv Bin/mbrola /usr/bin/mbrola && \
    cd / && rm -rf MBROLA

COPY requirements.txt .
RUN pip install -U -r requirements.txt uvloop jishaku && \
    pip install -U ./aiohttp-git[speedups] && \
    rm -rf aiohttp-git && pip cache purge

RUN python3 -u -m voxpopuli.voice_install all

COPY . .
CMD ["python3", "-u", "main.py"]
