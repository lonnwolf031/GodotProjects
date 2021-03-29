using UnityEngine;
using UnityEngine.UI;
using System.Collections.Generic;
using System.Linq;
public class Scorecard : MonoBehaviour
{
    public int BlueTogglesOn { get; private set; }
    public int RedTogglesOn { get; private set; }
    public int YellowTogglesOn { get; private set; }
    public int PurpleTogglesOn { get; private set; }
    public int NoScoreTogglesOn { get; private set; }

    public List<GameObject> blueToggles;
    public List<GameObject> redToggles;
    public List<GameObject> yellowToggles;
    public List<GameObject> purpleToggles;
    public List<GameObject> noscoreToggles;

    private void Awake()
    {
        blueToggles = new List<GameObject>();
        redToggles = new List<GameObject>();
        yellowToggles = new List<GameObject>();
        purpleToggles = new List<GameObject>();
        noscoreToggles = new List<GameObject>();
        blueToggles = GameObject.FindGameObjectsWithTag("blueToggle").ToList();
        redToggles = GameObject.FindGameObjectsWithTag("redToggle").ToList();
        yellowToggles = GameObject.FindGameObjectsWithTag("yellowToggle").ToList();
        purpleToggles = GameObject.FindGameObjectsWithTag("purpleToggle").ToList();
        noscoreToggles = GameObject.FindGameObjectsWithTag("noscoreToggle").ToList();
    }

    private void Start()
    {
        foreach (GameObject g in blueToggles)
        {
            var toggle = g.GetComponent<Toggle>();
            if (toggle.isOn)
            {
                BlueTogglesOn++;
            }
            toggle.onValueChanged.AddListener(OnBlueToggleValueChanged);
        }
        foreach (GameObject g in redToggles)
        {
            var toggle = g.GetComponent<Toggle>();
            if (toggle.isOn)
            {
                RedTogglesOn++;
            }
            toggle.onValueChanged.AddListener(OnRedToggleValueChanged);
        }
        foreach (GameObject g in yellowToggles)
        {
            var toggle = g.GetComponent<Toggle>();
            if (toggle.isOn)
            {
                YellowTogglesOn++;
            }
            toggle.onValueChanged.AddListener(OnYellowToggleValueChanged);
        }
        foreach (GameObject g in purpleToggles)
        {
            var toggle = g.GetComponent<Toggle>();
            if (toggle.isOn)
            {
                PurpleTogglesOn++;
            }
            toggle.onValueChanged.AddListener(OnPurpleToggleValueChanged);
        }
        foreach (GameObject g in noscoreToggles)
        {
            var toggle = g.GetComponent<Toggle>();
            if (toggle.isOn)
            {
                NoScoreTogglesOn++;
            }
            toggle.onValueChanged.AddListener(OnNoScoreToggleValueChanged);
        }
    }

    private void OnBlueToggleValueChanged(bool isOn)
    {
        BlueTogglesOn += isOn ? 1 : -1;
    }
    private void OnRedToggleValueChanged(bool isOn)
    {
        RedTogglesOn += isOn ? 1 : -1;
    }
    private void OnYellowToggleValueChanged(bool isOn)
    {
        YellowTogglesOn += isOn ? 1 : -1;
    }
    private void OnPurpleToggleValueChanged(bool isOn)
    {
        PurpleTogglesOn += isOn ? 1 : -1;
    }
    private void OnNoScoreToggleValueChanged(bool isOn)
    {
        NoScoreTogglesOn += isOn ? 1 : -1;
    }

    public int countRowScore(int numToggled)
    {
        int rowScore = 0;
        switch (numToggled)
        {
            case 1:
                rowScore = 1;
                break;
            case 2:
                rowScore = 3;
                break;
            case 3:
                rowScore = 6;
                break;
            case 4:
                rowScore = 10;
                break;
            case 5:
                rowScore = 15;
                break;
            case 6:
                rowScore = 21;
                break;
            case 7:
                rowScore = 28;
                break;
            case 8:
                rowScore = 36;
                break;
            case 9:
                rowScore = 45;
                break;
            case 10:
                rowScore = 55;
                break;
            case 11:
                rowScore = 66;
                break;
            case 12:
                rowScore = 78;
                break;
        }
        return rowScore;
    }

    public void countTotalScore()
    {
        int blueScore = countRowScore(BlueTogglesOn);
        int redScore = countRowScore(RedTogglesOn);
        int yellowScore = countRowScore(YellowTogglesOn);
        int purpleScore = countRowScore(PurpleTogglesOn);
        int subtractScore = NoScoreTogglesOn * 5;
        int totalScore = blueScore + redScore + yellowScore + purpleScore - subtractScore;

        var txtBlue = GameObject.Find("txtBluePt").GetComponent<Text>();
        txtBlue.text = blueScore.ToString();
        var txtRed = GameObject.Find("txtRedPt").GetComponent<Text>();
        txtRed.text = redScore.ToString();
        var txtYellow = GameObject.Find("txtYellowPt").GetComponent<Text>();
        txtYellow.text = yellowScore.ToString();
        var txtPurple = GameObject.Find("txtPurplePt").GetComponent<Text>();
        txtPurple.text = purpleScore.ToString();
        var txtSubtract = GameObject.Find("txtSubtractPt").GetComponent<Text>();
        txtSubtract.text = subtractScore.ToString();
        var txtTotal = GameObject.Find("txtTotalPt").GetComponent<Text>();
        txtTotal.text = totalScore.ToString();
    }
}