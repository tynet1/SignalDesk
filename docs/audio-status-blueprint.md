# Audio and Status Blueprint

This document defines the phase-3 path after the headless control plane is stable.

## Goal

Provide browser-native status and audio without depending on the SDRTrunk desktop session.

## Recommended architecture

1. SDRTrunk decodes and emits stream output per alias/talkgroup.
2. Local ingest service receives call/audio metadata and audio payloads.
3. Web UI serves:
- active calls
- recent calls
- browser audio playback

## Implementation options

### Option A: Integrate an existing ingest/UI stack

- Lowest implementation time
- Tradeoff: project lifecycle and API model constraints

### Option B: Custom local ingest + minimal web UI

- Build a small local service for ingest and playback index
- Use a lightweight UI optimized for your exact workflow
- Tradeoff: more initial engineering, lower long-term dependency risk

## Compatibility checkpoints

1. Audio format compatibility
- Verify the ingest service supports SDRTrunk output mode you configure.

2. Clock and timezone consistency
- Ensure host time is synchronized for accurate call ordering.

3. Storage growth
- Audio retention can grow quickly; define retention policy up front.

4. Latency budget
- Browser playback can lag if transcode/buffering is misconfigured.

## Pitfalls to avoid

1. Using VNC as primary listening interface
- Works for control, poor for daily audio experience.

2. Scaling all talkgroups on day one
- Start with 1-3 high-value talkgroups first.

3. No retention policy
- Leads to disk exhaustion and service flapping.

4. Tight coupling between decode and web UI
- Keep ingest/UI decoupled so decoder restarts do not kill playback history.

## Acceptance criteria

- Browser can play audio for at least one talkgroup reliably.
- Active call status updates in near-real-time.
- Audio retention and cleanup work automatically.
- Decoder restarts do not corrupt ingest service state.
