<template>
    <div class="track-play-back-control">
        <div class="track-play-back-control-buttons">
            <button class="track-play-back-control-button-play" @click="$emit('play')">
                <svg
                    v-if="isPlaying"
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke-width="1"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                >
                    <polygon points="5 3 9 3 9 21 5 21 5 3" />
                    <polygon points="15 3 19 3 19 21 15 21 15 3" />
                </svg>

                <svg
                    v-else
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke-width="1"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                >
                    <polygon points="7 3 22 12 7 21 7 3" />
                </svg>
            </button>
            <div class="track-play-back-control-buttons-speed">
                <button class="track-play-back-control-button-slow" @click="$emit('slow')">
                    <svg
                        xmlns="http://www.w3.org/2000/svg"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke-width="1"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                    >
                        <polygon points="11 19 2 12 11 5 11 19" />
                        <polygon points="22 19 13 12 22 5 22 19" />
                    </svg>
                </button>
                <button class="track-play-back-control-button-quick" @click="$emit('quick')">
                    <svg
                        xmlns="http://www.w3.org/2000/svg"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke-width="1"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                    >
                        <polygon points="13 19 22 12 13 5 13 19" />
                        <polygon points="2 19 11 12 2 5 2 19" />
                    </svg>
                </button>
            </div>
        </div>
        <div class="track-play-back-control-info">Скорость: x{{ speed }}</div>
    </div>
</template>

<script>
export default {
    name: 'TrackPlayBackControllerButtons',
    props: {
        speed: {
            type: Number,
            required: true
        },
        isPlaying: {
            type: Boolean,
            required: true
        }
    }
};
</script>

<style>
.track-play-back-control {
    width: 100px;
    margin-bottom: var(--translate-y);
    padding: 0 5px;
    border-top: 1px solid var(--color-border);
    border-right: 1px solid var(--color-border);
    display: flex;
    flex-direction: column;
    justify-content: center;
}

.track-play-back-control-buttons {
    display: flex;
    flex-direction: column;
    box-sizing: border-box;
    margin-top: 3px;
}

.track-play-back-control-buttons button {
    border: 1px solid;
    border-radius: 2px;
    border-color: var(--color-button-stroke);
    box-sizing: border-box;
    background: none;
    cursor: pointer;
    display: flex;
    justify-content: center;
    align-items: center;
    transition: border-color 0.25s ease, background-color 0.25s ease;
}

.track-play-back-control-buttons svg {
    fill: var(--color-button-stroke);
    stroke: var(--color-button-stroke);
    transition: fill 0.25s ease, stroke 0.25s ease;
}

.track-play-back-control-buttons button:hover,
.track-play-back-control-buttons button:focus {
    outline: none;
    background-color: var(--color-button-opacity);
    border-color: var(--color-button-stroke);
}

.track-play-back-control-buttons button:active {
    transition: none;
    background-color: var(--color-button-active-opacity);
    border-color: var(--color-button-stroke-active);
}

.track-play-back-control-buttons button:active svg {
    fill: var(--color-button-active-opacity);
    stroke: var(--color-button-stroke-active);
}

.is-playing .track-play-back-control-button-play {
    background-color: var(--color-button-active-opacity);
    border-color: var(--color-button-stroke-active);
}

.is-playing .track-play-back-control-button-play svg {
    stroke: var(--color-button-stroke-active);
    fill: var(--color-button-active);
}

.is-playing .track-play-back-control-button-play:hover,
.is-playing .track-play-back-control-button-play:focus {
    background-color: var(--color-button-active-opacity);
    border-color: var(--color-button-stroke-active);
}

.track-play-back-control-button-play {
    width: 100%;
}

.track-play-back-control-button-play svg {
    height: 20px;
    width: 30px;
}

.track-play-back-control-buttons-speed {
    display: flex;
    justify-content: space-between;
    margin-top: 3px;
}

.track-play-back-control-button-slow {
    width: 45%;
}

.track-play-back-control-button-quick {
    width: 45%;
}

.track-play-back-control-button-slow svg,
.track-play-back-control-button-quick svg {
    height: 16px;
}

.track-play-back-control-info {
    text-align: center;
    font-size: 11px;
    color: #4d4d4d;
    height: 16px;
}

.track-play-back-timeline {
    flex-grow: 1;
}
</style>
