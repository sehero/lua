class BrooksLaw(Model):
    def __init__(self, params):
        super(BrooksLaw, self).__init__(params)
        self.params = params

    def have(i): return Things(
        aR=Flow("assimilationRate"),
        co=Percent("communicationOverhead"),
        d=Stock("developedSoftware", i.params.d),
        ep=Stock("experiencedPeople", int(i.params.ep)),
        ept=Aux("experiencedPeopleNeeded2Train"),
        nprod=Aux("nominalProductity", i.params.nprod),
        np=Stock("newPersonnel", int(i.params.np)),
        paR=Flow("personnelAllocationRate"),
        ps=Aux("plannedSoftware"),
        sdR=Flow("softwareDevelopmentRate"),
        ts=Aux("teamSize", i.params.ts),
        # one-quarter of an experienced
        to=Percent("trainingOverhead", i.params.to),
        # person's time is needed to
        # train a new person until
        # he/she is fully assimilated.
        r=Stock("requirements", i.params.r))

    def step(self, dt, t, i, j):
        def _co(x):
            "Communication overhead"
            myTeam = i.ts - 1   # talk to everyone in my team
            others = x / i.ts - 1  # talk to every other team
            return self.params.pomposity * (myTeam**2 + others**2)  # pomposity
        j.aR = i.np / self.params.learning_curve  # 20 = Learning curve
        j.ps = self.params.optimism * t  # Optimism
        j.co = _co(i.ep + i.np)
        # Don't touch 6 and zero.
        j.paR = 6 if (
            i.ps - i.d) < self.params.atleast and t < int(self.params.done_percent * t / 100) else 0
        j.sdR = i.nprod * (1 - i.co / 100) * (self.params.productivity_new
                                              * i.np + self.params.productivity_exp * (i.ep - i.ept))
        j.ept = i.np * i.to / 100
        j.ep += i.aR * dt
        j.np += (i.paR - i.aR) * dt
        j.d += i.sdR * dt
        j.r -= i.sdR * dt
        return j


class MonteCarlo:
    def __init__(self):
        self.attr = {
            "pomposity": {
                "min": 0,
                "max": 100
            },
            "learning_curve": {
                "min": 1,
                "max": 100
            },
            "optimism": {
                "min": 0.1,
                "max": 100
            },
            "atleast": {
                "min": 0,
                "max": 10
            },
            "done_percent": {
                "min": 0,
                "max": 10
            },
            "productivity_new": {
                "min": 0,
                "max": 1
            },
            "productivity_exp": {
                "min": 1,
                "max": 10
            },
            "d": {
                "min": 0,
                "max": 1
            },
            "ep": {
                "min": 1,
                "max": 10
            },
            "nprod": {
                "min": 0.1,
                "max": 10
            },
            "np": {
                "min": 1,
                "max": 30
            },
            "ts": {
                "min": 1,
                "max": 100
            },
            "to": {
                "min": 1,
                "max": 100
            },
            "r": {
                "min": 1,
                "max": 1000
            }
