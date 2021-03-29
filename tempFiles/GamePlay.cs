using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GamePlay : MonoBehaviour
{
    public GameObject[] diceArr;
    public Color32[] diceColorArr;
    public const int numDices = 6;
    public Color tempCol;
    Color32 nBlue;
    Color32 nOrange;
    Color32 nYellow;
    Color32 nPurple;
    Color32 nWhite;

    void Awake()
    {
        nBlue = new Color32(3, 190, 237, 255);
        nOrange = new Color32(237, 73, 3, 255);
        nYellow = new Color32(237, 190, 3, 255);
        nPurple = new Color32(143, 3, 237, 255);
        nWhite = new Color32(255, 255, 255, 255);
        diceArr = new GameObject[numDices];
        diceColorArr = new Color32[6];
        diceColorArr[0] = nBlue;
        diceColorArr[1] = nOrange;
        diceColorArr[2] = nYellow;
        diceColorArr[3] = nPurple;
        diceColorArr[4] = nWhite;
        diceColorArr[5] = nWhite;
    }


    // Start is called before the first frame update
    void Start()
    {       
        for (int i=0; i<numDices; i++)
        {
            string dicename = "Dice" + i.ToString();
            diceArr[i] = GameObject.Find(dicename);
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void rollDice()
    {
        // assign color from fixed assortment and random value, also load SVG
        ShuffleColorArray();
        for(int i = 0; i < diceArr.Length; i++)
        {
            int num = Random.Range(1, 7);
            var diceRenderer = diceArr[i].GetComponent<Renderer>();
            diceRenderer.material.SetColor("_Color", diceColorArr[i]);
            string spriteName = "side" + num.ToString();
            Sprite diceSprite = Resources.Load(spriteName, typeof(Sprite)) as Sprite;
            diceArr[i].GetComponent<SVGImage>().sprite = diceSprite ;
        }       
    }

    public void ShuffleColorArray()
    {
        for (int i = 0; i < diceColorArr.Length - 1; i++)
        {
            int rnd = Random.Range(i, diceColorArr.Length);
            tempCol = diceColorArr[rnd];
            diceColorArr[rnd] = diceColorArr[i];
            diceColorArr[i] = tempCol;
        }
    }
}
