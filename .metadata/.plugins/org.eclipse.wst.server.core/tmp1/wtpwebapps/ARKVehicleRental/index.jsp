
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
<meta name="description" content="ARK Vehicle Rentals - Discover vehicles and manage your rental journey.">
<title>ARK | Premium Vehicle Rentals</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<style>
:root {
    --black: #080909;
    --dark: #0d0e0e;
    --panel: #121312;
    --gold: #d6ad64;
    --gold-light: #f0d49a;
    --white: #f8f6f1;
    --muted: #a5a39d;
    --line: rgba(214,173,100,.24);
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
    scroll-padding-top: 90px;
}

body {
    background: var(--black);
    color: var(--white);
    font-family: var(--sans);
    overflow-x: hidden;
}

body.menu-open {
    overflow: hidden;
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

button:focus-visible, a:focus-visible {
    outline: 2px solid var(--gold-light);
    outline-offset: 5px;
}

.gold {
    color: var(--gold-light);
}

.gold-line {
    width: 100%;
    height: 1px;
    background: linear-gradient(90deg, transparent, var(--gold), transparent);
    opacity: .7;
}

/* NAVIGATION */

.navbar {
    position: absolute;
    z-index: 100;
    top: 0;
    left: 0;
    width: 100%;
    min-height: 88px;
    padding: 0 7%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    border-bottom: 1px solid rgba(255,255,255,.12);
    transition: background .35s, min-height .35s, border-color .35s;
}

.navbar.scrolled {
    position: fixed;
    min-height: 72px;
    background: rgba(8,9,9,.96);
    backdrop-filter: blur(18px);
    border-bottom-color: var(--line);
    animation: navDrop .35s ease both;
}

.brand {
    display: flex;
    align-items: center;
    gap: 13px;
    flex-shrink: 0;
}

.brand-symbol {
    width: 41px;
    height: 41px;
    display: grid;
    place-items: center;
    border: 1px solid var(--gold);
    color: var(--gold-light);
    transform: rotate(45deg);
    box-shadow: 0 0 20px rgba(214,173,100,.08);
}

.brand-symbol span {
    font-family: var(--serif);
    font-size: 27px;
    font-weight: 600;
    transform: rotate(-45deg);
}

.brand-name {
    font-family: var(--serif);
    font-size: 29px;
    font-weight: 600;
    letter-spacing: 7px;
}

.brand-subtitle {
    display: block;
    margin-top: 2px;
    color: var(--gold);
    font-size: 8px;
    letter-spacing: 2.6px;
}

.nav-links {
    display: flex;
    align-items: center;
    gap: 29px;
}

.nav-links a {
    position: relative;
    color: #e5e2dc;
    font-size: 10px;
    font-weight: 500;
    letter-spacing: 1.1px;
    transition: color .25s;
}

.nav-links a:not(.nav-cta)::after {
    content: "";
    position: absolute;
    bottom: -9px;
    left: 0;
    width: 0;
    height: 1px;
    background: var(--gold);
    transition: width .3s ease;
}

.nav-links a:hover {
    color: var(--gold-light);
}

.nav-links a:hover::after {
    width: 100%;
}

.nav-links .nav-cta {
    padding: 14px 19px;
    border: 1px solid var(--gold);
    color: var(--gold-light);
    transition: background .3s, color .3s;
}

.nav-links .nav-cta:hover {
    background: var(--gold);
    color: #111;
}

.menu-toggle {
    display: none;
    width: 42px;
    height: 42px;
    border: 1px solid var(--line);
    background: transparent;
    color: var(--gold-light);
    font-size: 24px;
    cursor: pointer;
}

/* HERO */

.hero {
    position: relative;
    isolation: isolate;
    min-height: 730px;
    height: 94svh;
    max-height: 1000px;
    display: flex;
    align-items: center;
    overflow: hidden;
    background: #151513;
}

.hero-image {
    position: absolute;
    z-index: -3;
    inset: 0;
    background-image: url("https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=2400&q=90");
    background-size: cover;
    background-position: center 57%;
    transform: scale(1.04);
    animation: heroZoom 14s ease-out both;
}

.hero::before {
    content: "";
    position: absolute;
    z-index: -2;
    inset: 0;
    background:
        linear-gradient(90deg,
            rgba(7,8,8,.91) 0%,
            rgba(7,8,8,.76) 29%,
            rgba(7,8,8,.36) 60%,
            rgba(7,8,8,.13) 100%),
        linear-gradient(0deg,
            rgba(8,9,9,.98) 0%,
            transparent 42%,
            rgba(8,9,9,.16) 100%);
}

.hero::after {
    content: "";
    position: absolute;
    z-index: -1;
    inset: 0;
    pointer-events: none;
    background: linear-gradient(115deg, transparent 40%, rgba(214,173,100,.045), transparent 80%);
}

.hero-content {
    width: 100%;
    max-width: 740px;
    margin-left: 10%;
    padding: 110px 0 65px;
    animation: heroEnter 1s .15s ease both;
}

.eyebrow {
    display: flex;
    align-items: center;
    gap: 14px;
    color: var(--gold-light);
    font-size: 10px;
    font-weight: 600;
    letter-spacing: 3.5px;
}

.eyebrow::before {
    content: "";
    width: 40px;
    height: 1px;
    background: var(--gold);
}

.hero h1 {
    margin-top: 27px;
    font-family: var(--serif);
    font-size: clamp(65px, 7.2vw, 105px);
    font-weight: 400;
    line-height: .96;
    letter-spacing: -2px;
}

.hero h1 span {
    display: block;
    color: var(--gold-light);
    font-style: italic;
}

.hero-description {
    max-width: 420px;
    margin-top: 27px;
    color: #d0cdc6;
    font-size: 12px;
    font-weight: 300;
    line-height: 2;
}

.hero-actions {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 15px;
    margin-top: 34px;
}

.btn {
    min-height: 52px;
    padding: 0 23px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 13px;
    border: 1px solid transparent;
    font-size: 9px;
    font-weight: 600;
    letter-spacing: 1.35px;
    text-transform: uppercase;
    cursor: pointer;
    transition: background .3s, color .3s, border-color .3s, transform .3s;
}

.btn:hover {
    transform: translateY(-3px);
}

.btn-gold {
    color: #10100e;
    background: var(--gold);
    border-color: var(--gold);
}

.btn-gold:hover {
    background: var(--gold-light);
    border-color: var(--gold-light);
    box-shadow: 0 8px 28px rgba(214,173,100,.13);
}

.btn-outline {
    color: var(--white);
    background: rgba(255,255,255,.025);
    border-color: rgba(255,255,255,.4);
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

.hero-index {
    position: absolute;
    right: 7%;
    bottom: 100px;
    display: flex;
    align-items: center;
    gap: 12px;
    color: rgba(255,255,255,.75);
    font-size: 9px;
    letter-spacing: 2px;
    writing-mode: vertical-rl;
}

.hero-index::before {
    content: "";
    width: 1px;
    height: 48px;
    background: var(--gold);
}

/* FEATURES */

.feature-strip {
    position: relative;
    z-index: 2;
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    padding: 0 7%;
    background: #0d0e0e;
    border-top: 1px solid var(--line);
    border-bottom: 1px solid rgba(255,255,255,.07);
}

.feature {
    min-height: 120px;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 17px;
    padding: 20px 16px;
    border-right: 1px solid rgba(255,255,255,.08);
    transition: background .35s;
}

.feature:first-child {
    border-left: 1px solid rgba(255,255,255,.08);
}

.feature:hover {
    background: rgba(214,173,100,.045);
}

.feature-icon {
    flex-shrink: 0;
    width: 43px;
    height: 43px;
    display: grid;
    place-items: center;
    border: 1px solid var(--line);
    color: var(--gold);
    font-size: 20px;
    transition: transform .4s, background .4s;
}

.feature:hover .feature-icon {
    transform: rotate(45deg);
    background: rgba(214,173,100,.08);
}

.feature-icon span {
    transition: transform .4s;
}

.feature:hover .feature-icon span {
    transform: rotate(-45deg);
}

.feature h3 {
    margin-bottom: 8px;
    font-size: 11px;
    font-weight: 600;
    letter-spacing: .5px;
}

.feature p {
    max-width: 210px;
    color: var(--muted);
    font-size: 10px;
    line-height: 1.8;
}

/* HOW IT WORKS */

.how-it-works {
    padding: 105px 8% 100px;
    background:
        radial-gradient(ellipse at 50% 0%, rgba(214,173,100,.055), transparent 55%),
        #0a0b0b;
    border-bottom: 1px solid rgba(214,173,100,.15);
}

.section-heading {
    margin: 0 auto 54px;
    text-align: center;
}

.section-label {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 13px;
    color: var(--gold);
    font-size: 9px;
    font-weight: 600;
    letter-spacing: 3px;
}

.section-label::before,
.section-label::after {
    content: "";
    width: 26px;
    height: 1px;
    background: var(--gold);
}

.section-heading h2 {
    margin-top: 19px;
    font-family: var(--serif);
    font-size: clamp(47px, 5vw, 68px);
    font-weight: 400;
    line-height: 1.1;
}

.section-heading h2 span {
    color: var(--gold-light);
    font-style: italic;
}

.section-heading > p {
    margin-top: 13px;
    color: var(--muted);
    font-size: 12px;
    line-height: 1.9;
}

.steps-grid {
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    max-width: 1300px;
    margin: auto;
    border-top: 1px solid var(--line);
    border-bottom: 1px solid var(--line);
}

.step-card {
    position: relative;
    min-width: 0;
    padding: 27px 22px 31px;
    border-right: 1px solid rgba(255,255,255,.08);
    transition: background .35s, transform .35s;
}

.step-card:first-child {
    border-left: 1px solid rgba(255,255,255,.08);
}

.step-card:hover {
    z-index: 1;
    background: rgba(214,173,100,.045);
    transform: translateY(-5px);
}

.step-top {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 30px;
}

.step-number {
    color: var(--gold);
    font-size: 10px;
    letter-spacing: 2px;
}

.step-icon {
    width: 42px;
    height: 42px;
    display: grid;
    place-items: center;
    border: 1px solid var(--line);
    color: var(--gold-light);
    font-size: 20px;
    transition: transform .35s;
}

.step-card:hover .step-icon {
    transform: rotate(45deg);
}

.step-card h3 {
    margin-bottom: 12px;
    font-family: var(--serif);
    font-size: 24px;
    font-weight: 500;
}

.step-card p {
    color: var(--muted);
    font-size: 11px;
    line-height: 1.9;
}

.step-line {
    display: block;
    width: 32px;
    height: 2px;
    margin-top: 22px;
    background: var(--gold);
    transition: width .35s;
}

.step-card:hover .step-line {
    width: 68px;
}

.how-action {
    display: flex;
    justify-content: center;
    margin-top: 37px;
}

/* ARK EXPERIENCE */

.experience {
    position: relative;
    overflow: hidden;
    padding: 120px 9% 125px;
    background:
        radial-gradient(ellipse at 10% 70%, rgba(214,173,100,.045), transparent 40%),
        var(--black);
}

.experience::after {
    content: "ARK";
    position: absolute;
    right: -30px;
    bottom: -100px;
    color: rgba(214,173,100,.025);
    font-family: var(--serif);
    font-size: clamp(250px, 35vw, 520px);
    line-height: 1;
    pointer-events: none;
}

.experience-grid {
    position: relative;
    z-index: 1;
    max-width: 1320px;
    margin: auto;
    display: grid;
    grid-template-columns: 1.04fr .96fr;
    align-items: center;
    gap: clamp(45px, 7vw, 105px);
}

.experience-visual {
    position: relative;
    min-height: 440px;
}

.experience-photo {
    position: absolute;
    inset: 0 28px 30px 0;
    overflow: hidden;
    background-image:
        linear-gradient(0deg, rgba(0,0,0,.15), transparent 55%),
        url("https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=1400&q=85");
    background-size: cover;
    background-position: center;
    filter: saturate(.75);
    transition: filter .6s;
}

.experience-visual:hover .experience-photo {
    filter: saturate(1);
}

.experience-photo::after {
    content: "";
    position: absolute;
    inset: 0;
    border: 1px solid rgba(214,173,100,.25);
}

.photo-outline {
    position: absolute;
    z-index: -1;
    inset: 22px 0 7px 22px;
    border: 1px solid rgba(214,173,100,.55);
    transition: transform .4s;
}

.experience-visual:hover .photo-outline {
    transform: translate(5px, -5px);
}

.photo-caption {
    position: absolute;
    bottom: 0;
    left: 30px;
    padding: 16px 20px;
    background: var(--gold);
    color: #111;
    font-size: 8px;
    font-weight: 700;
    letter-spacing: 1.6px;
}

.experience-copy .section-label {
    justify-content: flex-start;
}

.experience-copy h2 {
    margin-top: 22px;
    font-family: var(--serif);
    font-size: clamp(48px, 5vw, 72px);
    font-weight: 400;
    line-height: 1.02;
    letter-spacing: -1px;
}

.experience-copy h2 span {
    display: block;
    color: var(--gold-light);
    font-style: italic;
}

.experience-copy > p {
    max-width: 480px;
    margin-top: 23px;
    color: var(--muted);
    font-size: 12px;
    line-height: 2.05;
    font-weight: 300;
}

.experience-points {
    display: flex;
    flex-wrap: wrap;
    gap: 16px 22px;
    margin-top: 26px;
    padding-top: 21px;
    border-top: 1px solid var(--line);
}

.experience-point {
    display: flex;
    align-items: center;
    gap: 8px;
    color: #d4d0c7;
    font-size: 10px;
}

.experience-point span {
    color: var(--gold);
    font-size: 14px;
}

.experience-copy .btn {
    margin-top: 29px;
}

/* CALL TO ACTION */

.final-cta {
    position: relative;
    padding: 78px 8%;
    text-align: center;
    background:
        linear-gradient(rgba(9,10,10,.91), rgba(9,10,10,.96)),
        url("https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=1800&q=80") center 60% / cover;
    border-top: 1px solid var(--line);
    border-bottom: 1px solid var(--line);
}

.final-cta .section-label {
    justify-content: center;
}

.final-cta h2 {
    margin-top: 17px;
    font-family: var(--serif);
    font-size: clamp(40px, 5vw, 62px);
    font-weight: 400;
}

.final-cta p {
    max-width: 450px;
    margin: 15px auto 27px;
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
    gap: 23px;
    padding: 30px 7%;
    background: #080909;
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
    font-size: 10px;
    line-height: 1.9;
}

.footer-links {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
}

.footer-links a {
    color: #a6a39a;
    font-size: 10px;
    transition: color .25s;
}

.footer-links a:hover {
    color: var(--gold-light);
}

/* SCROLL ANIMATIONS
   Content remains visible if JavaScript is unavailable. */

.reveal {
    opacity: 1;
    transform: none;
}

body.motion-ready .reveal {
    opacity: 0;
    transform: translateY(24px);
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

@keyframes heroEnter {
    from {
        opacity: 0;
        transform: translateY(24px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes heroZoom {
    from { transform: scale(1.04); }
    to { transform: scale(1); }
}

@keyframes navDrop {
    from { transform: translateY(-8px); }
    to { transform: translateY(0); }
}

/* TABLET */

@media (max-width: 950px) {
    .navbar {
        padding: 0 5%;
    }

    .nav-links {
        gap: 19px;
    }

    .hero-content {
        margin-left: 7%;
        margin-right: 6%;
    }

    .feature-strip {
        padding: 0 3%;
    }

    .feature {
        gap: 11px;
        padding: 18px 10px;
    }

    .experience {
        padding: 95px 6%;
    }

    .experience-grid {
        gap: 42px;
    }

    .experience-visual {
        min-height: 380px;
    }

    .step-card {
        padding: 24px 15px;
    }
}

/* MOBILE */

@media (max-width: 680px) {
    .navbar {
        min-height: 75px;
        padding: 0 6%;
    }

    .navbar.scrolled {
        min-height: 68px;
    }

    .brand-symbol {
        width: 34px;
        height: 34px;
    }

    .brand-symbol span {
        font-size: 22px;
    }

    .brand-name {
        font-size: 25px;
        letter-spacing: 5px;
    }

    .brand-subtitle {
        font-size: 7px;
        letter-spacing: 1.8px;
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
        padding: 8px 6% 20px;
        background: rgba(8,9,9,.98);
        border-bottom: 1px solid var(--line);
    }

    .nav-links.open {
        display: flex;
        animation: heroEnter .25s ease both;
    }

    .nav-links a {
        padding: 17px 4px;
        border-bottom: 1px solid rgba(255,255,255,.06);
    }

    .nav-links a:not(.nav-cta)::after {
        display: none;
    }

    .nav-links .nav-cta {
        margin-top: 12px;
        text-align: center;
    }

    .hero {
        min-height: 690px;
        height: 92svh;
        max-height: 850px;
    }

    .hero-image {
        background-position: 60% center;
    }

    .hero::before {
        background:
            linear-gradient(90deg, rgba(7,8,8,.84), rgba(7,8,8,.27)),
            linear-gradient(0deg, rgba(7,8,8,.98), transparent 80%);
    }

    .hero-content {
        margin: 0 7%;
        padding-top: 100px;
    }

    .eyebrow {
        font-size: 8px;
        letter-spacing: 2px;
    }

    .hero h1 {
        margin-top: 24px;
        font-size: clamp(55px, 12vw, 76px);
    }

    .hero-description {
        max-width: 340px;
        font-size: 11px;
    }

    .hero-actions {
        align-items: stretch;
        flex-direction: column;
        max-width: 260px;
        gap: 11px;
    }

    .hero-index {
        display: none;
    }

    .feature-strip {
        grid-template-columns: 1fr;
        padding: 0 6%;
    }

    .feature,
    .feature:first-child {
        justify-content: flex-start;
        min-height: 91px;
        padding: 18px 10px;
        border-left: 0;
        border-right: 0;
        border-bottom: 1px solid rgba(255,255,255,.08);
    }

    .feature:last-child {
        border-bottom: 0;
    }

    .how-it-works {
        padding: 75px 6%;
    }

    .section-heading {
        margin-bottom: 35px;
    }

    .section-heading h2 {
        font-size: 48px;
    }

    .steps-grid {
        grid-template-columns: 1fr;
    }

    .step-card,
    .step-card:first-child {
        border-left: 1px solid rgba(255,255,255,.08);
        border-right: 1px solid rgba(255,255,255,.08);
    }

    .step-card + .step-card {
        border-top: 1px solid rgba(255,255,255,.08);
    }

    .step-card {
        padding: 23px 20px;
    }

    .step-top {
        margin-bottom: 21px;
    }

    .step-card p {
        max-width: 370px;
    }

    .experience {
        padding: 75px 7% 85px;
    }

    .experience-grid {
        grid-template-columns: 1fr;
        gap: 42px;
    }

    .experience-visual {
        min-height: 320px;
        margin-right: 7px;
    }

    .experience-photo {
        inset: 0 20px 25px 0;
    }

    .photo-outline {
        inset: 17px 0 5px 17px;
    }

    .photo-caption {
        left: 14px;
        padding: 13px 15px;
        font-size: 7px;
    }

    .experience-copy h2 {
        font-size: 54px;
    }

    .experience-copy > p {
        font-size: 11px;
    }

    .experience-points {
        gap: 15px;
    }

    .final-cta {
        padding: 65px 7%;
    }

    .footer {
        align-items: flex-start;
        flex-direction: column;
        padding: 29px 7%;
    }

    .footer-links {
        gap: 16px;
    }
}

/* REDUCED MOTION ACCESSIBILITY */

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
</style>
</head>

<body>

<!-- NAVBAR -->
<header class="navbar" id="navbar">
    <a class="brand" href="<%= context %>/index.jsp" aria-label="ARK Home">
        <div class="brand-symbol"><span>A</span></div>
        <div>
            <div class="brand-name">ARK</div>
            <span class="brand-subtitle">VEHICLE RENTALS</span>
        </div>
    </a>

    <button class="menu-toggle" id="menuToggle"
            type="button" aria-label="Open navigation"
            aria-controls="navLinks" aria-expanded="false">
        &#9776;
    </button>

    
<nav class="navbar">
    <a href="<%= request.getContextPath() %>/index.jsp" class="brand">
        ARK
    </a>

    <div class="nav-links">
        <a href="<%= request.getContextPath() %>">Home</a>
        
    </div>
</nav>

</header>

<main>

    <!-- HERO SECTION -->
    <section class="hero">
        <div class="hero-image" aria-hidden="true"></div>

        <div class="hero-content">
            <div class="eyebrow">THE ART OF THE DRIVE</div>

            <h1>
                Your Journey
                <span>Begins Here.</span>
            </h1>

            <p class="hero-description">
                Discover a better way to travel. Explore a curated
                collection of vehicles, enjoy a straightforward
                booking experience, and make every journey count.
            </p>

            <div class="hero-actions">
                <a class="btn btn-gold" href="<%= context %>/login.jsp">
                    START YOUR JOURNEY
                    <span class="btn-arrow">&#8594;</span>
                </a>

                <a class="btn btn-outline" href="<%= context %>/register.jsp">
                    CREATE ACCOUNT
                </a>
            </div>
        </div>

        <div class="hero-index">01 &nbsp; / &nbsp; THE ARK EXPERIENCE</div>
    </section>

    <div class="gold-line"></div>

    <!-- FEATURE STRIP -->
    <section class="feature-strip" aria-label="ARK features">
        <div class="feature">
            <div class="feature-icon"><span>&#9671;</span></div>
            <div>
                <h3>Explore Vehicles</h3>
                <p>Find a vehicle for your next journey.</p>
            </div>
        </div>

        <div class="feature">
            <div class="feature-icon"><span>&#9711;</span></div>
            <div>
                <h3>Flexible Booking</h3>
                <p>Choose your dates and plan your travel.</p>
            </div>
        </div>

        <div class="feature">
            <div class="feature-icon"><span>&#10022;</span></div>
            <div>
                <h3>Manage Your Journey</h3>
                <p>Keep your bookings organized in one place.</p>
            </div>
        </div>
    </section>

    <!-- HOW IT WORKS -->
    <section class="how-it-works" id="how-it-works">
        <div class="section-heading reveal">
            <div class="section-label">A SIMPLE WAY TO TRAVEL</div>
            <h2>How It <span>Works.</span></h2>
            <p>Four simple steps to start your next journey.</p>
        </div>

        <div class="steps-grid">
            <article class="step-card reveal">
                <div class="step-top">
                    <span class="step-number">01</span>
                    <span class="step-icon">&#9671;</span>
                </div>
                <h3>Explore Vehicles</h3>
                <p>Sign in and browse the available vehicles to find one that suits your journey.</p>
                <span class="step-line"></span>
            </article>

            <article class="step-card reveal delay-1">
                <div class="step-top">
                    <span class="step-number">02</span>
                    <span class="step-icon">&#9711;</span>
                </div>
                <h3>Choose Your Dates</h3>
                <p>Select your rental period and check whether your preferred vehicle is available.</p>
                <span class="step-line"></span>
            </article>

            <article class="step-card reveal delay-2">
                <div class="step-top">
                    <span class="step-number">03</span>
                    <span class="step-icon">&#10003;</span>
                </div>
                <h3>Submit a Booking</h3>
                <p>Submit your booking request and check its status in your bookings page.</p>
                <span class="step-line"></span>
            </article>

            <article class="step-card reveal delay-3">
                <div class="step-top">
                    <span class="step-number">04</span>
                    <span class="step-icon">&#8594;</span>
                </div>
                <h3>Manage Your Journey</h3>
                <p>Review your bookings, edit or cancel eligible requests, and use the demo payment flow.</p>
                <span class="step-line"></span>
            </article>
        </div>

        <div class="how-action reveal">
            <a class="btn btn-gold" href="<%= context %>/login.jsp">
                GET STARTED <span class="btn-arrow">&#8594;</span>
            </a>
        </div>
    </section>

    <!-- ARK EXPERIENCE -->
    <section class="experience" id="experience">
        <div class="experience-grid">
            <div class="experience-visual reveal">
                <div class="experience-photo"></div>
                <div class="photo-outline"></div>
                <div class="photo-caption">YOUR NEXT CHAPTER STARTS HERE</div>
            </div>

            <div class="experience-copy reveal delay-1">
                <div class="section-label">THE ARK EXPERIENCE</div>

                <h2>
                    Move Beyond
                    <span>Ordinary.</span>
                </h2>

                <p>
                    Every journey deserves a thoughtful experience.
                    ARK Vehicle Rentals brings vehicle discovery,
                    booking management, and a refined digital
                    interface together in one place.
                </p>

                <p>
                    Whether you are planning a weekend escape or
                    your next everyday drive, discover a simpler
                    way to manage your vehicle rental.
                </p>

                <div class="experience-points">
                    <div class="experience-point">
                        <span>&#10003;</span> Simple Booking
                    </div>
                    <div class="experience-point">
                        <span>&#10003;</span> Clear Rental Pricing
                    </div>
                    <div class="experience-point">
                        <span>&#10003;</span> Booking Management
                    </div>
                </div>

                <a class="btn btn-gold" href="<%= context %>/login.jsp">
                    DISCOVER ARK
                    <span class="btn-arrow">&#8594;</span>
                </a>
            </div>
        </div>
    </section>

    <!-- FINAL CALL TO ACTION -->
    <section class="final-cta reveal">
        <div class="section-label">YOUR NEXT JOURNEY AWAITS</div>
        <h2>Ready to Move?</h2>

        <p>
            Your next destination is waiting.
            Start your ARK journey today.
        </p>

        <a class="btn btn-gold" href="<%= context %>/register.jsp">
            JOIN ARK <span class="btn-arrow">&#8594;</span>
        </a>
    </section>

</main>

<!-- FOOTER -->
<footer class="footer">
    <a class="footer-brand" href="<%= context %>/index.jsp">
        ARK<span>.</span>
    </a>

    <p>
        Premium Vehicle Rentals<br>
        &copy; <%= java.time.Year.now() %> ARK Vehicle Rentals.
        All rights reserved.
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

    /* STICKY NAVIGATION */
    const navbar = document.getElementById("navbar");

    function updateNavbar() {
        if (navbar) {
            navbar.classList.toggle("scrolled", window.scrollY > 40);
        }
    }

    window.addEventListener("scroll", updateNavbar, { passive: true });
    updateNavbar();

    /* MOBILE NAVIGATION */
    const menuToggle = document.getElementById("menuToggle");
    const navLinks = document.getElementById("navLinks");

    function closeMenu() {
        if (!menuToggle || !navLinks) {
            return;
        }

        navLinks.classList.remove("open");
        document.body.classList.remove("menu-open");
        menuToggle.setAttribute("aria-expanded", "false");
        menuToggle.setAttribute("aria-label", "Open navigation");
        menuToggle.innerHTML = "&#9776;";
    }

    if (menuToggle && navLinks) {
        menuToggle.addEventListener("click", function () {
            const isOpen = navLinks.classList.toggle("open");

            document.body.classList.toggle("menu-open", isOpen);
            menuToggle.setAttribute("aria-expanded", String(isOpen));
            menuToggle.setAttribute(
                "aria-label",
                isOpen ? "Close navigation" : "Open navigation"
            );
            menuToggle.innerHTML = isOpen ? "&times;" : "&#9776;";
        });

        navLinks.querySelectorAll("a").forEach(function (link) {
            link.addEventListener("click", closeMenu);
        });

        window.addEventListener("resize", function () {
            if (window.innerWidth > 680) {
                closeMenu();
            }
        });
    }

    /* SCROLL REVEAL ANIMATIONS */
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
            rootMargin: "0px 0px -25px 0px"
        });

        /* Enable hidden-before-reveal styles only after setup succeeds. */
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
