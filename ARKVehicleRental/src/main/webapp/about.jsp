
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String context = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="theme-color" content="#080909">
<meta name="description" content="Discover the story, purpose, features and technology behind ARK Vehicle Rentals.">
<title>About ARK | The Black Label Experience</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<style>
:root {
    --black: #080909;
    --dark: #0c0d0d;
    --panel: #121312;
    --gold: #d6ad64;
    --gold-light: #f0d49a;
    --white: #f8f6f1;
    --muted: #aaa79f;
    --line: rgba(214,173,100,.25);
    --serif: "Cormorant Garamond", Georgia, serif;
    --sans: "Inter", Arial, sans-serif;
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

html {
    scroll-behavior: smooth;
    scroll-padding-top: 85px;
}

body {
    background: var(--black);
    color: var(--white);
    font-family: var(--sans);
    overflow-x: hidden;
}

a {
    color: inherit;
    text-decoration: none;
}

button {
    font: inherit;
}

a, button {
    -webkit-tap-highlight-color: transparent;
}

a:focus-visible, button:focus-visible {
    outline: 2px solid var(--gold-light);
    outline-offset: 4px;
}

.gold {
    color: var(--gold-light);
}

.gold-rule {
    height: 1px;
    background: linear-gradient(90deg, transparent, var(--gold), transparent);
    opacity: .65;
}



/* NAVBAR — MATCH YOUR SCREENSHOT */

.navbar {
    position: absolute;
    top: 0;
    left: 0;
    z-index: 1000;
    width: 100%;
    min-height: 132px;
    padding: 0 7%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    background: #151616;
    border-bottom: 1px solid rgba(214,173,100,.12);
    transition: background .35s, min-height .35s;
}

.navbar.scrolled {
    position: fixed;
    min-height: 90px;
    background: rgba(15,16,16,.97);
    backdrop-filter: blur(16px);
    box-shadow: 0 8px 30px rgba(0,0,0,.35);
}

.brand {
    display: flex;
    flex-direction: column;
    gap: 2px;
}

.brand-title {
    color: #d9b56b;
    font-family: Arial, sans-serif;
    font-size: 40px;
    font-weight: 800;
    letter-spacing: 8px;
    line-height: 1;
}

.brand-subtitle {
    display: block;
    margin-top: 8px;
    color: #e8e5de;
    font-size: 12px;
    font-weight: 400;
    letter-spacing: 2.6px;
}

.nav-links {
    display: flex;
    align-items: center;
    gap: 36px;
}

.nav-links a {
    position: relative;
    color: #f0eee9;
    font-size: 17px;
    font-weight: 400;
    text-decoration: none;
    transition: color .25s;
}

.nav-links a:hover,
.nav-links a.active {
    color: #d9b56b;
}

.nav-links .logout-link {
    padding: 15px 24px;
    border: 1px solid #d9b56b;
    border-radius: 10px;
    color: #f0eee9;
}

.nav-links .logout-link:hover {
    color: #111;
    background: #d9b56b;
}

.menu-toggle {
    display: none;
    width: 42px;
    height: 42px;
    color: #d9b56b;
    background: transparent;
    border: 1px solid rgba(214,173,100,.4);
    cursor: pointer;
    font-size: 23px;
}

@media (max-width: 900px) {
    .navbar {
        min-height: 100px;
        padding: 0 5%;
    }

    .navbar.scrolled {
        min-height: 78px;
    }

    .brand-title {
        font-size: 32px;
    }

    .brand-subtitle {
        font-size: 9px;
    }

    .nav-links {
        gap: 20px;
    }

    .nav-links a {
        font-size: 14px;
    }
}

@media (max-width: 700px) {
    .navbar {
        min-height: 82px;
        padding: 0 5%;
    }

    .navbar.scrolled {
        min-height: 75px;
    }

    .brand-title {
        font-size: 31px;
    }

    .menu-toggle {
        display: block;
    }

    .nav-links {
        position: absolute;
        top: 100%;
        left: 0;
        right: 0;
        display: none;
        flex-direction: column;
        align-items: stretch;
        gap: 0;
        padding: 10px 5% 20px;
        background: #111212;
        border-bottom: 1px solid rgba(214,173,100,.25);
    }

    .nav-links.open {
        display: flex;
    }

    .nav-links a {
        padding: 16px 5px;
        font-size: 15px;
        border-bottom: 1px solid rgba(255,255,255,.06);
    }

    .nav-links .logout-link {
        margin-top: 12px;
        padding: 13px 16px;
        text-align: center;
        border: 1px solid #d9b56b;
    }
}


.menu-toggle {
    display: none;
    width: 40px;
    height: 40px;
    background: transparent;
    color: var(--gold-light);
    border: 1px solid var(--line);
    cursor: pointer;
    font-size: 22px;
}

/* HERO */

.about-hero {
    position: relative;
    isolation: isolate;
    min-height: 660px;
    padding: 125px 6% 48px;
    display: flex;
    align-items: center;
    overflow: hidden;
    background: #11120f;
}



.hero-image {
    position: absolute;
    z-index: -3;
    inset: 0;
    background-image: url("https://images.unsplash.com/photo-1603386329225-868f9b1ee6c9?auto=format&fit=crop&w=2400&q=90");
    background-size: cover;
    background-position: center 55%;
    background-repeat: no-repeat;
    transform: scale(1.03);
    animation: carReveal 1.5s ease-out both;
}



.about-hero::before {
    content: "";
    position: absolute;
    z-index: -2;
    inset: 0;
    background:
        linear-gradient(90deg,
            rgba(5,6,6,.96) 0%,
            rgba(5,6,6,.87) 29%,
            rgba(5,6,6,.48) 55%,
            rgba(5,6,6,.14) 100%),
        linear-gradient(0deg,
            rgba(8,9,9,.8),
            transparent 55%);
}

.about-hero::after {
    content: "";
    position: absolute;
    z-index: -1;
    right: -100px;
    bottom: -220px;
    width: 550px;
    height: 550px;
    border: 1px solid rgba(214,173,100,.16);
    border-radius: 50%;
    box-shadow:
        0 0 0 35px rgba(214,173,100,.025),
        0 0 0 75px rgba(214,173,100,.018);
    pointer-events: none;
}

.hero-content {
    width: 100%;
    max-width: 680px;
    animation: riseIn .9s .1s both;
}

.eyebrow {
    display: flex;
    align-items: center;
    gap: 13px;
    color: var(--gold-light);
    font-size: 10px;
    font-weight: 600;
    letter-spacing: 3px;
}

.eyebrow::before {
    content: "";
    width: 35px;
    height: 1px;
    background: var(--gold);
}

.about-hero h1 {
    margin-top: 27px;
    font-family: var(--serif);
    font-size: clamp(64px, 8vw, 110px);
    font-weight: 400;
    line-height: .9;
    letter-spacing: -2px;
}

.about-hero h1 span {
    display: block;
    color: var(--gold-light);
    font-style: italic;
}

.hero-description {
    max-width: 445px;
    margin-top: 25px;
    color: #d2cfc8;
    font-size: 12px;
    font-weight: 300;
    line-height: 2;
}

.hero-actions {
    display: flex;
    flex-wrap: wrap;
    gap: 13px;
    margin-top: 29px;
}

.btn {
    min-height: 49px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 12px;
    padding: 0 22px;
    border: 1px solid transparent;
    font-size: 9px;
    font-weight: 600;
    letter-spacing: 1.1px;
    text-transform: uppercase;
    transition: transform .3s, background .3s, color .3s, border-color .3s;
}

.btn:hover {
    transform: translateY(-3px);
}

.btn-gold {
    color: #111;
    background: var(--gold);
    border-color: var(--gold);
}

.btn-gold:hover {
    background: var(--gold-light);
    border-color: var(--gold-light);
}

.btn-outline {
    color: var(--white);
    border-color: rgba(255,255,255,.35);
    background: rgba(255,255,255,.025);
}

.btn-outline:hover {
    border-color: var(--gold);
    color: var(--gold-light);
}

.btn-arrow {
    display: inline-block;
    font-size: 17px;
    transition: transform .3s;
}

.btn:hover .btn-arrow {
    transform: translateX(4px);
}

.hero-note {
    position: absolute;
    right: 6%;
    bottom: 80px;
    max-width: 150px;
    color: rgba(255,255,255,.85);
    font-family: var(--serif);
    font-size: 23px;
    font-style: italic;
    line-height: 1.15;
    text-align: right;
}

.hero-note span {
    display: block;
    margin-top: 14px;
    color: var(--gold);
    font-family: var(--sans);
    font-size: 8px;
    font-style: normal;
    letter-spacing: 2px;
}

/* MISSION AND VISION */

.purpose {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    background: #0a0b0b;
    border-top: 1px solid var(--line);
    border-bottom: 1px solid var(--line);
}

.purpose-card {
    min-height: 185px;
    display: flex;
    align-items: center;
    gap: 19px;
    padding: 30px 8%;
    border-right: 1px solid rgba(255,255,255,.09);
    transition: background .35s;
}

.purpose-card:hover {
    background: rgba(214,173,100,.035);
}

.purpose-card:last-child {
    border-right: 0;
}

.purpose-icon {
    flex-shrink: 0;
    width: 51px;
    height: 51px;
    display: grid;
    place-items: center;
    border: 1px solid var(--gold);
    border-radius: 50%;
    color: var(--gold-light);
    font-size: 22px;
    transition: transform .4s, box-shadow .4s;
}

.purpose-card:hover .purpose-icon {
    transform: rotate(12deg);
    box-shadow: 0 0 20px rgba(214,173,100,.12);
}

.purpose-card h2 {
    margin-bottom: 8px;
    font-family: var(--serif);
    font-size: 27px;
    font-weight: 500;
}

.purpose-card p {
    color: var(--muted);
    font-size: 10px;
    line-height: 1.9;
}

/* SECTION HEADINGS */

.section {
    padding: 105px 7%;
}

.section-heading {
    max-width: 720px;
    margin-bottom: 45px;
}

.section-label {
    display: flex;
    align-items: center;
    gap: 12px;
    color: var(--gold);
    font-size: 9px;
    font-weight: 600;
    letter-spacing: 3px;
}

.section-label::before {
    content: "";
    width: 29px;
    height: 1px;
    background: var(--gold);
}

.section-heading h2 {
    margin-top: 19px;
    font-family: var(--serif);
    font-size: clamp(45px, 5.5vw, 72px);
    font-weight: 400;
    line-height: 1;
}

.section-heading h2 span {
    color: var(--gold-light);
    font-style: italic;
}

.section-heading p {
    max-width: 540px;
    margin-top: 18px;
    color: var(--muted);
    font-size: 12px;
    line-height: 2;
}

/* PROJECT OVERVIEW */

.overview {
    position: relative;
    overflow: hidden;
    background:
        radial-gradient(ellipse at 85% 20%, rgba(214,173,100,.055), transparent 40%),
        var(--black);
}

.overview-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    align-items: center;
    gap: 65px;
}

.overview-visual {
    position: relative;
    min-height: 410px;
}

.overview-photo {
    position: absolute;
    inset: 0 24px 25px 0;
    background:
        linear-gradient(0deg, rgba(0,0,0,.25), transparent 65%),
        url("https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=1300&q=85") center / cover;
    filter: saturate(.78);
    transition: filter .5s;
}

.overview-visual:hover .overview-photo {
    filter: saturate(1);
}

.overview-outline {
    position: absolute;
    z-index: -1;
    inset: 22px 0 4px 22px;
    border: 1px solid rgba(214,173,100,.6);
    transition: transform .35s;
}

.overview-visual:hover .overview-outline {
    transform: translate(5px,-5px);
}

.overview-stamp {
    position: absolute;
    left: 20px;
    bottom: 0;
    padding: 15px 20px;
    background: var(--gold);
    color: #111;
    font-size: 8px;
    font-weight: 700;
    letter-spacing: 1.5px;
}

.overview-copy h2 {
    margin-top: 19px;
    font-family: var(--serif);
    font-size: clamp(42px, 4.5vw, 62px);
    font-weight: 400;
    line-height: 1.03;
}

.overview-copy h2 span {
    display: block;
    color: var(--gold-light);
    font-style: italic;
}

.overview-copy > p {
    margin-top: 20px;
    color: var(--muted);
    font-size: 12px;
    line-height: 2.05;
}

.overview-points {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 14px;
    margin-top: 25px;
    padding-top: 22px;
    border-top: 1px solid var(--line);
}

.overview-point {
    display: flex;
    align-items: center;
    gap: 9px;
    color: #d9d5cd;
    font-size: 10px;
}

.overview-point span {
    color: var(--gold);
    font-size: 15px;
}

/* ADVANTAGES */

.advantages {
    background: #0d0e0e;
    border-top: 1px solid rgba(255,255,255,.06);
    border-bottom: 1px solid var(--line);
}

.advantages .section-heading {
    max-width: 750px;
}

.advantages-grid {
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    border-top: 1px solid var(--line);
    border-bottom: 1px solid var(--line);
}

.advantage-card {
    position: relative;
    min-height: 240px;
    padding: 28px 22px;
    border-right: 1px solid rgba(255,255,255,.08);
    transition: background .35s, transform .35s;
}

.advantage-card:first-child {
    border-left: 1px solid rgba(255,255,255,.08);
}

.advantage-card:hover {
    z-index: 1;
    background: rgba(214,173,100,.045);
    transform: translateY(-5px);
}

.advantage-icon {
    width: 49px;
    height: 49px;
    display: grid;
    place-items: center;
    color: var(--gold-light);
    border: 1px solid var(--line);
    font-size: 23px;
    transition: transform .4s;
}

.advantage-card:hover .advantage-icon {
    transform: rotate(45deg);
}

.advantage-number {
    position: absolute;
    top: 35px;
    right: 20px;
    color: rgba(214,173,100,.55);
    font-size: 9px;
    letter-spacing: 1px;
}

.advantage-card h3 {
    margin-top: 28px;
    font-family: var(--serif);
    font-size: 24px;
    font-weight: 500;
}

.advantage-card p {
    margin-top: 10px;
    color: var(--muted);
    font-size: 10px;
    line-height: 1.9;
}

.advantage-line {
    width: 30px;
    height: 2px;
    margin-top: 19px;
    background: var(--gold);
    transition: width .35s;
}

.advantage-card:hover .advantage-line {
    width: 62px;
}

/* WORKFLOW */

.workflow {
    background: var(--black);
}

.workflow-layout {
    display: grid;
    grid-template-columns: .75fr 1.25fr;
    gap: 75px;
    align-items: start;
}

.workflow-intro {
    position: sticky;
    top: 110px;
}

.workflow-intro h2 {
    margin-top: 20px;
    font-family: var(--serif);
    font-size: clamp(45px, 5vw, 67px);
    font-weight: 400;
    line-height: 1;
}

.workflow-intro h2 span {
    display: block;
    color: var(--gold-light);
    font-style: italic;
}

.workflow-intro p {
    margin-top: 20px;
    color: var(--muted);
    font-size: 12px;
    line-height: 2;
}

.workflow-intro .btn {
    margin-top: 27px;
}

.workflow-list {
    position: relative;
}

.workflow-list::before {
    content: "";
    position: absolute;
    top: 17px;
    bottom: 30px;
    left: 20px;
    width: 1px;
    background: linear-gradient(var(--gold), rgba(214,173,100,.08));
}

.workflow-item {
    position: relative;
    display: grid;
    grid-template-columns: 42px 1fr;
    gap: 22px;
    padding-bottom: 35px;
}

.workflow-item:last-child {
    padding-bottom: 0;
}

.workflow-number {
    position: relative;
    z-index: 1;
    width: 41px;
    height: 41px;
    display: grid;
    place-items: center;
    border: 1px solid var(--gold);
    border-radius: 50%;
    background: var(--black);
    color: var(--gold-light);
    font-size: 10px;
    transition: color .3s, background .3s;
}

.workflow-item:hover .workflow-number {
    background: var(--gold);
    color: #111;
}

.workflow-item h3 {
    margin: 2px 0 8px;
    font-family: var(--serif);
    font-size: 25px;
    font-weight: 500;
}

.workflow-item p {
    color: var(--muted);
    font-size: 11px;
    line-height: 1.9;
}

/* DEVELOPER SPOTLIGHT */

.developer {
    position: relative;
    overflow: hidden;
    background:
        radial-gradient(ellipse at 10% 50%, rgba(214,173,100,.07), transparent 42%),
        #0b0c0c;
    border-top: 1px solid var(--line);
}

.developer::after {
    content: "TM";
    position: absolute;
    right: -25px;
    bottom: -125px;
    color: rgba(214,173,100,.025);
    font-family: var(--serif);
    font-size: clamp(220px, 35vw, 430px);
    line-height: 1;
    pointer-events: none;
}

.developer-card {
    position: relative;
    z-index: 1;
    display: grid;
    grid-template-columns: .8fr 1.2fr;
    max-width: 1150px;
    margin: auto;
    overflow: hidden;
    border: 1px solid rgba(214,173,100,.35);
    background: rgba(16,17,16,.8);
    box-shadow: 0 25px 80px rgba(0,0,0,.22);
}

.developer-visual {
    position: relative;
    min-height: 410px;
    padding: 35px 20px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    overflow: hidden;
    background:
        linear-gradient(rgba(214,173,100,.035) 1px, transparent 1px),
        linear-gradient(90deg, rgba(214,173,100,.035) 1px, transparent 1px),
        #0a0b0b;
    background-size: 28px 28px;
    border-right: 1px solid var(--line);
}

.developer-visual::before {
    content: "";
    position: absolute;
    width: 260px;
    height: 260px;
    border-radius: 50%;
    background: rgba(214,173,100,.055);
    filter: blur(30px);
    animation: auraPulse 5s ease-in-out infinite;
}

.orbit-system {
    position: relative;
    width: 220px;
    height: 220px;
    display: grid;
    place-items: center;
}

.orbit-ring {
    position: absolute;
    inset: 0;
    border: 1px solid rgba(214,173,100,.35);
    border-radius: 50%;
    animation: orbitSpin 18s linear infinite;
}

.orbit-ring.ring-two {
    inset: 19px -10px;
    transform: rotate(45deg);
    border-color: rgba(214,173,100,.23);
    animation-duration: 24s;
    animation-direction: reverse;
}

.orbit-ring.ring-three {
    inset: -10px 18px;
    transform: rotate(-40deg);
    border-style: dashed;
    border-color: rgba(214,173,100,.18);
    animation-duration: 32s;
}

.orbit-particle {
    position: absolute;
    top: 15%;
    left: 12%;
    width: 7px;
    height: 7px;
    border-radius: 50%;
    background: var(--gold-light);
    box-shadow: 0 0 14px rgba(214,173,100,.8);
}

.ring-two .orbit-particle {
    top: auto;
    bottom: 13%;
    left: 15%;
    width: 5px;
    height: 5px;
}

.ring-three .orbit-particle {
    top: 40%;
    left: auto;
    right: 0;
    width: 4px;
    height: 4px;
}

.avatar {
    position: relative;
    z-index: 2;
    width: 116px;
    height: 116px;
    display: grid;
    place-items: center;
    border: 1px solid var(--gold);
    border-radius: 50%;
    background: radial-gradient(circle at 30% 25%, #27251e, #0b0c0b 70%);
    color: var(--gold-light);
    font-family: var(--serif);
    font-size: 51px;
    font-weight: 500;
    letter-spacing: -2px;
    box-shadow:
        0 0 0 7px rgba(214,173,100,.04),
        0 0 45px rgba(214,173,100,.12);
    animation: avatarFloat 5s ease-in-out infinite;
}

.developer-visual h3 {
    position: relative;
    margin-top: 29px;
    font-family: var(--serif);
    font-size: 30px;
    font-weight: 500;
    text-align: center;
}

.developer-role {
    position: relative;
    margin-top: 7px;
    color: var(--gold);
    font-size: 8px;
    letter-spacing: 2.5px;
}

.developer-details {
    padding: 49px 45px;
    align-self: center;
}

.developer-details .section-label {
    font-size: 8px;
    letter-spacing: 2px;
}

.developer-details h2 {
    margin-top: 20px;
    font-family: var(--serif);
    font-size: clamp(43px, 4.5vw, 62px);
    font-weight: 400;
    line-height: 1;
}

.developer-details h2 span {
    color: var(--gold-light);
    font-style: italic;
}

.developer-meta {
    margin-top: 14px;
    color: var(--gold);
    font-size: 9px;
    letter-spacing: 1px;
}

.developer-details > p {
    margin-top: 19px;
    color: var(--muted);
    font-size: 11px;
    line-height: 2;
}

.developer-divider {
    width: 100%;
    height: 1px;
    margin: 24px 0;
    background: linear-gradient(90deg, var(--gold), transparent);
}

.skill-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-top: 20px;
}

.skill-tags span {
    padding: 9px 10px;
    border: 1px solid rgba(214,173,100,.2);
    color: #d8d3c8;
    font-size: 8px;
    letter-spacing: .5px;
    transition: background .3s, border-color .3s;
}

.skill-tags span:hover {
    background: rgba(214,173,100,.07);
    border-color: var(--gold);
}

.developer-signature {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 15px;
    flex-wrap: wrap;
    margin-top: 27px;
    padding-top: 20px;
    border-top: 1px solid rgba(255,255,255,.08);
}

.developer-signature span:first-child {
    color: #88867e;
    font-size: 8px;
    letter-spacing: 1.4px;
}

.developer-signature span:last-child {
    color: var(--gold-light);
    font-family: var(--serif);
    font-size: 23px;
    font-style: italic;
}

/* TECHNOLOGY */

.technology {
    background: #0d0e0e;
    border-top: 1px solid rgba(255,255,255,.06);
}

.tech-grid {
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 12px;
}

.tech-card {
    position: relative;
    min-height: 115px;
    padding: 21px;
    border: 1px solid rgba(255,255,255,.09);
    background: rgba(255,255,255,.012);
    transition: border-color .3s, background .3s, transform .3s;
}

.tech-card:hover {
    transform: translateY(-4px);
    border-color: var(--gold);
    background: rgba(214,173,100,.035);
}

.tech-card span {
    color: var(--gold);
    font-size: 9px;
    letter-spacing: 1px;
}

.tech-card h3 {
    margin-top: 15px;
    font-family: var(--serif);
    font-size: 23px;
    font-weight: 500;
}

.tech-card p {
    margin-top: 5px;
    color: var(--muted);
    font-size: 9px;
    line-height: 1.7;
}

/* FINAL CTA */

.final-cta {
    position: relative;
    padding: 78px 7%;
    text-align: center;
    overflow: hidden;
    background:
        linear-gradient(rgba(6,7,7,.91), rgba(6,7,7,.95)),
        url("https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1800&q=85") center / cover;
    border-top: 1px solid var(--line);
}

.final-cta .section-label {
    justify-content: center;
}

.final-cta h2 {
    margin-top: 19px;
    font-family: var(--serif);
    font-size: clamp(43px, 6vw, 75px);
    font-weight: 400;
}

.final-cta h2 span {
    color: var(--gold-light);
    font-style: italic;
}

.final-cta p {
    max-width: 440px;
    margin: 16px auto 27px;
    color: var(--muted);
    font-size: 12px;
    line-height: 1.9;
}

/* FOOTER */

.footer {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 22px;
    padding: 28px 6%;
    background: #080909;
    border-top: 1px solid rgba(255,255,255,.06);
}

.footer-brand {
    font-family: var(--serif);
    font-size: 25px;
    letter-spacing: 5px;
}

.footer-brand span {
    color: var(--gold);
}

.footer p {
    color: #88867e;
    font-size: 9px;
    line-height: 1.9;
}

.footer-links {
    display: flex;
    flex-wrap: wrap;
    gap: 17px;
}

.footer-links a {
    color: #aaa79f;
    font-size: 9px;
    transition: color .25s;
}

.footer-links a:hover {
    color: var(--gold-light);
}

/* SCROLL REVEAL */

.reveal {
    opacity: 1;
    transform: none;
}

body.motion-ready .reveal {
    opacity: 0;
    transform: translateY(23px);
    transition: opacity .75s ease, transform .75s ease;
}

body.motion-ready .reveal.visible {
    opacity: 1;
    transform: translateY(0);
}

body.motion-ready .reveal.delay-1 {
    transition-delay: .1s;
}

body.motion-ready .reveal.delay-2 {
    transition-delay: .2s;
}

body.motion-ready .reveal.delay-3 {
    transition-delay: .3s;
}

/* ANIMATION KEYFRAMES */

@keyframes riseIn {
    from {
        opacity: 0;
        transform: translateY(25px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes imageReveal {
    from { transform: scale(1.035); }
    to { transform: scale(1); }
}

@keyframes orbitSpin {
    from { rotate: 0deg; }
    to { rotate: 360deg; }
}

@keyframes avatarFloat {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-7px); }
}

@keyframes auraPulse {
    0%, 100% { opacity: .5; transform: scale(.9); }
    50% { opacity: 1; transform: scale(1.08); }
}

/* TABLET */

@media (max-width: 1000px) {
    .navbar {
        padding: 0 4%;
    }

    .nav-links {
        gap: 18px;
    }

    .purpose-card {
        padding: 24px 5%;
        gap: 13px;
    }

    .overview-grid {
        gap: 42px;
    }

    .advantage-card {
        padding: 24px 15px;
    }

    .workflow-layout {
        gap: 40px;
    }

    .developer-details {
        padding: 38px 30px;
    }
}

/* MOBILE */

@media (max-width: 700px) {
    .navbar {
        min-height: 73px;
        padding: 0 6%;
    }

    .brand-mark {
        width: 34px;
        height: 34px;
    }

    .brand-mark span {
        font-size: 22px;
    }

    .brand-title {
        font-size: 25px;
        letter-spacing: 5px;
    }

    .brand-subtitle {
        font-size: 6px;
        letter-spacing: 1.7px;
    }

    .menu-toggle {
        display: block;
    }

    .nav-links {
        position: absolute;
        top: 100%;
        left: 0;
        right: 0;
        display: none;
        flex-direction: column;
        align-items: stretch;
        gap: 0;
        max-height: calc(100svh - 70px);
        overflow-y: auto;
        padding: 10px 6% 20px;
        background: rgba(8,9,9,.98);
        border-bottom: 1px solid var(--line);
    }

    .nav-links.open {
        display: flex;
        animation: riseIn .25s ease both;
    }

    .nav-links a {
        padding: 16px 3px;
        border-bottom: 1px solid rgba(255,255,255,.06);
    }

    .nav-links a:not(.nav-cta)::after {
        display: none;
    }

    .nav-links .nav-cta {
        margin-top: 12px;
        text-align: center;
    }

    .about-hero {
        min-height: 690px;
        padding: 115px 7% 60px;
        align-items: center;
    }

    .hero-image {
        background-position: 58% center;
    }

    .about-hero::before {
        background:
            linear-gradient(90deg, rgba(5,6,6,.91), rgba(5,6,6,.4)),
            linear-gradient(0deg, rgba(8,9,9,.92), transparent 80%);
    }

    .about-hero h1 {
        font-size: clamp(57px, 12vw, 80px);
    }

    .hero-description {
        max-width: 390px;
        font-size: 11px;
    }

    .hero-note {
        display: none;
    }

    .purpose {
        grid-template-columns: 1fr;
    }

    .purpose-card {
        min-height: 135px;
        padding: 23px 7%;
        border-right: 0;
        border-bottom: 1px solid rgba(255,255,255,.08);
    }

    .purpose-card:last-child {
        border-bottom: 0;
    }

    .section {
        padding: 75px 7%;
    }

    .overview-grid {
        grid-template-columns: 1fr;
        gap: 40px;
    }

    .overview-visual {
        min-height: 300px;
        margin-right: 8px;
    }

    .overview-copy h2 {
        font-size: 50px;
    }

    .advantages-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    .advantage-card {
        min-height: 220px;
        padding: 22px 16px;
    }

    .advantage-card:nth-child(3) {
        border-left: 1px solid rgba(255,255,255,.08);
    }

    .advantage-card:nth-child(n+3) {
        border-top: 1px solid rgba(255,255,255,.08);
    }

    .workflow-layout {
        grid-template-columns: 1fr;
        gap: 40px;
    }

    .workflow-intro {
        position: static;
    }

    .developer-card {
        grid-template-columns: 1fr;
    }

    .developer-visual {
        min-height: 330px;
        border-right: 0;
        border-bottom: 1px solid var(--line);
    }

    .developer-details {
        padding: 33px 25px;
    }

    .developer-details h2 {
        font-size: 48px;
    }

    .tech-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    .tech-card {
        padding: 17px;
    }

    .final-cta {
        padding: 65px 7%;
    }

    .footer {
        flex-direction: column;
        align-items: flex-start;
        padding: 28px 7%;
    }
}

@media (max-width: 390px) {
    .hero-actions {
        align-items: stretch;
        flex-direction: column;
        max-width: 260px;
    }

    .overview-points {
        grid-template-columns: 1fr;
    }

    .advantages-grid {
        grid-template-columns: 1fr;
    }

    .advantage-card,
    .advantage-card:first-child,
    .advantage-card:nth-child(3) {
        border-left: 1px solid rgba(255,255,255,.08);
        border-right: 1px solid rgba(255,255,255,.08);
    }

    .advantage-card + .advantage-card {
        border-top: 1px solid rgba(255,255,255,.08);
    }

    .tech-grid {
        grid-template-columns: 1fr;
    }
}

/* ACCESSIBILITY */

@media (prefers-reduced-motion: reduce) {
    *,
    *::before,
    *::after {
        animation-duration: .01ms !important;
        animation-iteration-count: 1 !important;
        scroll-behavior: auto !important;
        transition-duration: .01ms !important;
    }

    body.motion-ready .reveal {
        opacity: 1;
        transform: none;
    }
}


/* ===== TECHNOLOGY CARDS ANIMATION ===== */

.tech-card {
    position: relative;
    overflow: hidden;
    background: #101010;
    border: 1px solid #292929;
    padding: 32px;
    transition:
        transform 0.4s ease,
        border-color 0.4s ease,
        background 0.4s ease,
        box-shadow 0.4s ease;
    transform-style: preserve-3d;
}

/* Gold light sweep */
.tech-card::before {
    content: "";
    position: absolute;
    top: 0;
    left: -130%;
    width: 80%;
    height: 100%;
    background: linear-gradient(
        110deg,
        transparent,
        rgba(212, 175, 97, 0.10),
        transparent
    );
    transform: skewX(-20deg);
    transition: left 0.7s ease;
    pointer-events: none;
}

/* Hover effect */
.tech-card:hover {
    transform: translateY(-9px);
    border-color: #d4af61;
    background: #171512;
    box-shadow:
        0 12px 30px rgba(0, 0, 0, 0.35),
        0 0 18px rgba(212, 175, 97, 0.10);
}

.tech-card:hover::before {
    left: 150%;
}

/* Animate the numbered category */
.tech-card .tech-label {
    display: inline-block;
    color: #d4af61;
    transition: transform 0.35s ease, letter-spacing 0.35s ease;
}

.tech-card:hover .tech-label {
    transform: translateX(5px);
    letter-spacing: 1.8px;
}

/* Technology title */
.tech-card h3 {
    transition:
        color 0.35s ease,
        transform 0.35s ease;
}

.tech-card:hover h3 {
    color: #e7c77f;
    transform: translateX(5px);
}

/* Description */
.tech-card p {
    transition: color 0.35s ease, transform 0.35s ease;
}

.tech-card:hover p {
    color: #e2ddd3;
    transform: translateX(3px);
}

/* Keyboard accessibility */
.tech-card:focus-within {
    outline: 1px solid #d4af61;
    outline-offset: 4px;
}

/* Respect reduced-motion preferences */
@media (prefers-reduced-motion: reduce) {
    .tech-card,
    .tech-card::before,
    .tech-card h3,
    .tech-card p,
    .tech-card .tech-label {
        transition: none !important;
    }

    .tech-card:hover {
        transform: none;
    }
}


</style>
</head>

<body>
<jsp:include page="/navbar.jsp" />
<!-- NAVIGATION -->




<main>

    <!-- ABOUT HERO -->
    <section class="about-hero">
        <div class="hero-image" aria-hidden="true"></div>

        <div class="hero-content">
            <div class="eyebrow">THE STORY BEHIND ARK</div>

            <h1>
                Driven by
                <span>Better Journeys.</span>
            </h1>

            <p class="hero-description">
                ARK Vehicle Rentals is an Advanced Java web application
                built to bring vehicle discovery, rental bookings, and
                account management into one organized experience.
                Our aim is to make the rental process clear and convenient.
            </p>

            <div class="hero-actions">
                <a class="btn btn-gold" href="#overview">
                    EXPLORE OUR STORY <span class="btn-arrow">&#8594;</span>
                </a>

                <a class="btn btn-outline" href="<%= context %>/index.jsp">
                    BACK TO HOME
                </a>
            </div>
        </div>

        <div class="hero-note">
            More than rentals.
            <br>We create journeys.
            <span>THE ARK EXPERIENCE</span>
        </div>
    </section>

    <div class="gold-rule"></div>

    <!-- MISSION AND VISION -->
    <section class="purpose" aria-label="Our purpose">

        <article class="purpose-card reveal">
            <div class="purpose-icon">&#9671;</div>
            <div>
                <h2>Our Mission</h2>
                <p>
                    To provide a straightforward vehicle rental
                    experience through organized browsing,
                    booking, and account management.
                </p>
            </div>
        </article>

        <article class="purpose-card reveal delay-1">
            <div class="purpose-icon">&#10022;</div>
            <div>
                <h2>Our Vision</h2>
                <p>
                    To demonstrate how thoughtful web development
                    can make vehicle rental workflows clearer
                    and easier to manage.
                </p>
            </div>
        </article>

        <article class="purpose-card reveal delay-2">
            <div class="purpose-icon">&#8599;</div>
            <div>
                <h2>Our Approach</h2>
                <p>
                    Bring together a considered interface,
                    database-driven features, and practical
                    server-side application logic.
                </p>
            </div>
        </article>

    </section>

    <!-- PROJECT OVERVIEW -->
    <section class="section overview" id="overview">
        <div class="overview-grid">

            <div class="overview-visual reveal">
                <div class="overview-photo"></div>
                <div class="overview-outline"></div>
                <div class="overview-stamp">DESIGNED FOR THE JOURNEY</div>
            </div>

            <div class="overview-copy reveal delay-1">
                <div class="section-label">THE IDEA BEHIND THE PROJECT</div>

                <h2>
                    Technology with
                    <span>a Purpose.</span>
                </h2>

                <p>
                    ARK Vehicle Rentals is a web-based vehicle rental
                    management project developed using Java web
                    technologies. Customers can explore vehicles,
                    submit rental bookings, and manage eligible
                    bookings through the application.
                </p>

                <p>
                    The administrative workflow supports vehicle
                    management and the review of customer, booking,
                    and payment records. Together, these features
                    demonstrate how front-end design, server-side
                    programming, and a relational database can work
                    as one application.
                </p>

                <div class="overview-points">
                    <div class="overview-point">
                        <span>&#10003;</span> Vehicle Browsing
                    </div>
                    <div class="overview-point">
                        <span>&#10003;</span> Booking Management
                    </div>
                    <div class="overview-point">
                        <span>&#10003;</span> User Accounts
                    </div>
                    <div class="overview-point">
                        <span>&#10003;</span> Admin Management
                    </div>
                </div>

                <a class="btn btn-gold" href="<%= context %>" style="margin-top:27px">
                    EXPLORE ARK <span class="btn-arrow">&#8594;</span>
                </a>
            </div>

        </div>
    </section>

    <!-- WHY ARK -->
    <section class="section advantages" id="advantages">
        <div class="section-heading reveal">
            <div class="section-label">OUR ADVANTAGE</div>
            <h2>Why Choose <span>ARK?</span></h2>
            <p>
                A practical rental workflow supported by an organized
                interface and clear application features.
            </p>
        </div>

        <div class="advantages-grid">

            <article class="advantage-card reveal">
                <div class="advantage-icon">&#9671;</div>
                <span class="advantage-number">01 / DISCOVER</span>
                <h3>Vehicle Selection</h3>
                <p>
                    Browse the available vehicles and review
                    their details before choosing your rental.
                </p>
                <div class="advantage-line"></div>
            </article>

            <article class="advantage-card reveal delay-1">
                <div class="advantage-icon">&#10022;</div>
                <span class="advantage-number">02 / CLARITY</span>
                <h3>Rental Details</h3>
                <p>
                    Review rental dates and the calculated
                    booking amount before submitting a request.
                </p>
                <div class="advantage-line"></div>
            </article>

            <article class="advantage-card reveal delay-2">
                <div class="advantage-icon">&#10003;</div>
                <span class="advantage-number">03 / CONTROL</span>
                <h3>Booking Management</h3>
                <p>
                    Access booking information and manage
                    eligible requests through your account.
                </p>
                <div class="advantage-line"></div>
            </article>

            <article class="advantage-card reveal delay-3">
                <div class="advantage-icon">&#9881;</div>
                <span class="advantage-number">04 / OPERATIONS</span>
                <h3>Admin Tools</h3>
                <p>
                    Support vehicle administration and the
                    management of customer and booking records.
                </p>
                <div class="advantage-line"></div>
            </article>

        </div>
    </section>

    <!-- HOW IT WORKS -->
    <section class="section workflow" id="workflow">
        <div class="workflow-layout">

            <div class="workflow-intro reveal">
                <div class="section-label">THE RENTAL JOURNEY</div>
                <h2>
                    From Browse
                    <span>to Booking.</span>
                </h2>
                <p>
                    The ARK workflow connects vehicle discovery,
                    rental date selection, booking submission,
                    and booking management in a simple sequence.
                </p>

                <a class="btn btn-gold"
                   href="<%= context %>/index.jsp#how-it-works">
                    VIEW HOMEPAGE <span class="btn-arrow">&#8594;</span>
                </a>
            </div>

            <div class="workflow-list">

                <article class="workflow-item reveal">
                    <div class="workflow-number">01</div>
                    <div>
                        <h3>Explore Vehicles</h3>
                        <p>
                            Sign in and browse the vehicles available
                            in the rental system.
                        </p>
                    </div>
                </article>

                <article class="workflow-item reveal delay-1">
                    <div class="workflow-number">02</div>
                    <div>
                        <h3>Choose Your Dates</h3>
                        <p>
                            Select the intended rental period and
                            check availability through the application.
                        </p>
                    </div>
                </article>

                <article class="workflow-item reveal delay-2">
                    <div class="workflow-number">03</div>
                    <div>
                        <h3>Submit a Booking</h3>
                        <p>
                            Submit the booking request and review
                            its status from your bookings page.
                        </p>
                    </div>
                </article>

                <article class="workflow-item reveal delay-3">
                    <div class="workflow-number">04</div>
                    <div>
                        <h3>Manage Your Booking</h3>
                        <p>
                            Review eligible bookings and use the
                            application's demo payment workflow.
                            It does not process real payments.
                        </p>
                    </div>
                </article>

            </div>
        </div>
    </section>

    <!-- DEVELOPER SPOTLIGHT -->
    <section class="section developer" id="developer">
        <div class="section-heading reveal">
            <div class="section-label">THE PERSON BEHIND THE PROJECT</div>
            <h2>Built with <span>Intention.</span></h2>
            <p>
                A student project focused on bringing Java web
                development, database operations, and interface
                design together.
            </p>
        </div>

        <div class="developer-card reveal">

            <div class="developer-visual">
                <div class="orbit-system" aria-label="Animated TM monogram">
                    <div class="orbit-ring">
                        <span class="orbit-particle"></span>
                    </div>

                    <div class="orbit-ring ring-two">
                        <span class="orbit-particle"></span>
                    </div>

                    <div class="orbit-ring ring-three">
                        <span class="orbit-particle"></span>
                    </div>

                    <div class="avatar">TM</div>
                </div>

                <h3>Tanush Muddapur</h3>
                <div class="developer-role">PROJECT DEVELOPER</div>
            </div>

            <div class="developer-details">
                <div class="section-label">THE CREATOR'S CORNER</div>

                <h2>
                    Tanush
                    <span>Muddapur.</span>
                </h2>

                <div class="developer-meta">
                    BCA STUDENT &nbsp; / &nbsp; ADVANCED JAVA PROJECT
                </div>

                <p>
                    ARK Vehicle Rentals was developed as a practical
                    application of Java web development concepts.
                    The project combines JSP pages, Jakarta Servlets,
                    JDBC database connectivity, and Oracle Database
                    to support vehicle rental workflows.
                </p>

                <div class="developer-divider"></div>

                <p>
                    Its interface brings together a premium visual
                    direction and functional application pages,
                    with an emphasis on organized navigation,
                    understandable booking steps, and account-based
                    access.
                </p>
<%--
                <div class="skill-tags">
                    <span>JAVA</span>
                    <span>JSP</span>
                    <span>JAKARTA SERVLETS</span>
                    <span>JDBC</span>
                    <span>ORACLE DATABASE</span>
                    <span>HTML &amp; CSS</span>
                    <span>JAVASCRIPT</span>
                </div>

                <div class="developer-signature">
                    <span>DESIGNED &amp; DEVELOPED BY</span>
                    <span>Tanush Muddapur</span>
                </div>
            </div>

        </div>
    </section>

    <!-- TECHNOLOGY STACK -->
    <section class="section technology" id="technology">
        <div class="section-heading reveal">
            <div class="section-label">UNDER THE HOOD</div>
            <h2>The Technology <span>Behind ARK.</span></h2>
            <p>
                The technologies used to build the interface,
                process application requests, and store rental data.
            </p>
        </div>

        <div class="tech-grid">

            <article class="tech-card reveal">
                <span>01 / LANGUAGE</span>
                <h3>Java</h3>
                <p>Application logic and server-side processing.</p>
            </article>

            <article class="tech-card reveal delay-1">
                <span>02 / WEB PAGES</span>
                <h3>JSP</h3>
                <p>Dynamic pages and server-rendered content.</p>
            </article>

            <article class="tech-card reveal delay-2">
                <span>03 / REQUESTS</span>
                <h3>Jakarta Servlets</h3>
                <p>Request handling and application workflows.</p>
            </article>

            <article class="tech-card reveal delay-3">
                <span>04 / CONNECTIVITY</span>
                <h3>JDBC</h3>
                <p>Communication between Java and the database.</p>
            </article>

            <article class="tech-card reveal">
                <span>05 / DATA</span>
                <h3>Oracle Database</h3>
                <p>Persistent storage for rental application records.</p>
            </article>

            <article class="tech-card reveal delay-1">
                <span>06 / INTERFACE</span>
                <h3>HTML5</h3>
                <p>Page structure and semantic content.</p>
            </article>

            <article class="tech-card reveal delay-2">
                <span>07 / PRESENTATION</span>
                <h3>CSS3</h3>
                <p>Responsive layouts, styling, and animations.</p>
            </article>

            <article class="tech-card reveal delay-3">
                <span>08 / INTERACTION</span>
                <h3>JavaScript</h3>
                <p>Navigation interactions and scroll animations.</p>
            </article>

        </div>--%>
    </section>

    <!-- CLOSING CTA -->
    <section class="final-cta reveal">
        <div class="section-label">YOUR NEXT CHAPTER</div>

        <h2>Every Journey Has <span>a Beginning.</span></h2>

        <p>
            Explore the ARK Vehicle Rentals application
            and discover the rental workflow for yourself.
        </p>

        <a class="btn btn-gold" href="<%= context %>/login.jsp">
            EXPLORE ARK <span class="btn-arrow">&#8594;</span>
        </a>
    </section>

</main>

<!-- FOOTER -->
<footer class="footer">
    <a class="footer-brand" href="<%= context %>/index.jsp">
        ARK<span>.</span>
    </a>

    <p>
        ARK Vehicle Rentals<br>
        &copy; <%= java.time.Year.now() %> All rights reserved.
    </p>

    <div class="footer-links">
        <a href="<%= context %>/index.jsp">Home</a>
        <a href="<%= context %>/about.jsp">About</a>
        <a href="<%= context %>/index.jsp#how-it-works">How It Works</a>
        <a href="<%= context %>/login.jsp">Login</a>
        <a href="<%= context %>/register.jsp">Register</a>
    </div>
</footer>

<script>
(function () {
    "use strict";

    /* HOMEPAGE-STYLE NAVBAR SCROLL EFFECT */
    (function () {
        const navbar = document.getElementById("navbar");

        if (!navbar) return;

        let ticking = false;

        function updateNavbar() {
            navbar.classList.toggle("scrolled", window.scrollY > 45);
            ticking = false;
        }

        window.addEventListener("scroll", function () {
            if (!ticking) {
                window.requestAnimationFrame(updateNavbar);
                ticking = true;
            }
        }, { passive: true });

        /* Correct state on initial load and page refresh */
        updateNavbar();
    })();


    /* MOBILE MENU */
    
const menuToggle = document.getElementById("menuToggle");
const navLinks = document.getElementById("navLinks");

if (menuToggle && navLinks) {
    menuToggle.addEventListener("click", function () {
        const open = navLinks.classList.toggle("open");

        menuToggle.setAttribute("aria-expanded", String(open));
        menuToggle.setAttribute(
            "aria-label",
            open ? "Close navigation" : "Open navigation"
        );
        menuToggle.innerHTML = open ? "&times;" : "&#9776;";
    });

    navLinks.querySelectorAll("a").forEach(function (link) {
        link.addEventListener("click", function () {
            navLinks.classList.remove("open");
            menuToggle.setAttribute("aria-expanded", "false");
            menuToggle.setAttribute("aria-label", "Open navigation");
            menuToggle.innerHTML = "&#9776;";
        });
    });
}


    /* SCROLL REVEAL */
    const revealItems = document.querySelectorAll(".reveal");
    const reduceMotion = window.matchMedia(
        "(prefers-reduced-motion: reduce)"
    ).matches;

    if (
        "IntersectionObserver" in window &&
        !reduceMotion &&
        revealItems.length > 0
    ) {
        const observer = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    entry.target.classList.add("visible");
                    observer.unobserve(entry.target);
                }
            });
        }, {
            threshold: 0.12,
            rootMargin: "0px 0px -20px 0px"
        });

        document.body.classList.add("motion-ready");

        revealItems.forEach(function (item) {
            observer.observe(item);
        });
    } else {
        revealItems.forEach(function (item) {
            item.classList.add("visible");
        });
    }
})();
</script>

</body>
</html>
